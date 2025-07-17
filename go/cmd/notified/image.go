package main

import (
	"errors"
	"fmt"
	"image"
	"image/color"
	"image/png"
	"os"
	"path/filepath"
)

var ImageCacheDir = filepath.Join(os.TempDir(), "notified")

func CacheImage(id uint32, kind string, img image.Image) (string, error) {
	cacheDir := filepath.Join(ImageCacheDir, fmt.Sprint(id))
	EnsureDirectoryMust(cacheDir)

	path := filepath.Join(cacheDir, fmt.Sprintf("%s.png", kind))

	file, err := os.Create(path)
	if err != nil {
		return "", err
	}
	defer file.Close()

	err = png.Encode(file, img)
	if err != nil {
		return "", err
	}

	return path, nil
}

func DecodeDBusImageStruct(data any) (image.Image, error) {
	structure, ok := data.([]any)
	if !ok || len(structure) != 7 {
		return nil, errors.New("invalid image-data structure")
	}

	// Safely extract all fields with proper type checking
	width, ok := structure[0].(int32)
	if !ok {
		return nil, errors.New("width must be int32")
	}
	height, ok := structure[1].(int32)
	if !ok {
		return nil, errors.New("height must be int32")
	}
	rowstride, ok := structure[2].(int32)
	if !ok {
		return nil, errors.New("rowstride must be int32")
	}
	hasAlpha, ok := structure[3].(bool)
	if !ok {
		return nil, errors.New("hasAlpha must be bool")
	}
	bitsPerSample, ok := structure[4].(int32)
	if !ok {
		return nil, errors.New("bitsPerSample must be int32")
	}
	channels, ok := structure[5].(int32)
	if !ok {
		return nil, errors.New("channels must be int32")
	}

	// Validate basic parameters
	if width <= 0 || height <= 0 {
		return nil, errors.New("invalid image dimensions")
	}
	if bitsPerSample != 8 {
		return nil, errors.New("only 8-bit samples supported")
	}
	if channels < 1 || channels > 4 {
		return nil, errors.New("channels must be between 1 and 4")
	}

	// Convert pixel data to []byte
	var raw []byte
	switch v := structure[6].(type) {
	case []byte:
		raw = v
	case []any:
		raw = make([]byte, len(v))
		for i, val := range v {
			switch b := val.(type) {
			case uint8:
				raw[i] = b
			case int32:
				if b < 0 || b > 255 {
					return nil, fmt.Errorf("value out of byte range at index %d", i)
				}
				raw[i] = byte(b)
			default:
				return nil, fmt.Errorf("non-byte in image data at index %d (type %T)", i, val)
			}
		}
	default:
		return nil, fmt.Errorf("unexpected image data type: %T", structure[6])
	}

	img := image.NewRGBA(image.Rect(0, 0, int(width), int(height)))
	pixelSize := int(channels)
	expectedSize := int(height) * int(rowstride)

	if len(raw) < expectedSize {
		return nil, fmt.Errorf("image data too small: expected at least %d bytes, got %d",
			expectedSize, len(raw))
	}

	for y := 0; y < int(height); y++ {
		for x := 0; x < int(width); x++ {
			offset := y*int(rowstride) + x*pixelSize
			if offset+pixelSize > len(raw) {
				return nil, errors.New("image data out of bounds")
			}

			var r, g, b, a uint8
			switch channels {
			case 1: // Grayscale
				r = raw[offset]
				g = raw[offset]
				b = raw[offset]
				a = 255
			case 2: // Grayscale + Alpha
				r = raw[offset]
				g = raw[offset]
				b = raw[offset]
				a = raw[offset+1]
			case 3: // RGB
				r = raw[offset]
				g = raw[offset+1]
				b = raw[offset+2]
				a = 255
			case 4: // RGBA or ARGB?
				if hasAlpha {
					// Assuming RGBA format
					r = raw[offset]
					g = raw[offset+1]
					b = raw[offset+2]
					a = raw[offset+3]
				} else {
					// No alpha but 4 channels? Maybe CMYK or something else
					r = raw[offset]
					g = raw[offset+1]
					b = raw[offset+2]
					a = 255
				}
			}

			img.SetRGBA(x, y, color.RGBA{R: r, G: g, B: b, A: a})
		}
	}

	return img, nil
}
