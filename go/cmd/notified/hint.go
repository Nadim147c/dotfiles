package main

import (
	"image"
	"log/slog"
	"reflect"

	"github.com/godbus/dbus/v5"
)

type Urgency uint32

const (
	UrgencyLow Urgency = iota
	UrgencyNormal
	UrgencyCritical
)

type Hints struct {
	RawHints  map[string]dbus.Variant
	Urgency   Urgency     `json:"urgency"`
	SenderPID uint32      `json:"sender_pid"`
	ImageData image.Image `json:"-"`
	ImagePath string      `json:"image_path,omitzero"`
	IconData  image.Image `json:"-"`
	IconPath  string      `json:"icon_path,omitzero"`
}

func ParseHints(id uint32, hints map[string]dbus.Variant) Hints {
	parsed := Hints{
		RawHints: hints,
	}

	keys := make([]string, 0, len(hints))
	for key := range hints {
		keys = append(keys, key)
	}

	slog.Debug("Parsing notification hints",
		"notification_id", id,
		"hint_count", len(hints),
		"hints", keys)

	if v, ok := hints["icon_data"]; ok {
		slog.Debug("Found icon_data hint", "notification_id", id)
		if img, err := DecodeDBusImageStruct(v.Value()); err == nil {
			parsed.IconData = img
			path, err := CacheImage(id, "icon", img)
			if err == nil {
				parsed.IconPath = path
				slog.Debug("Cached icon image", "notification_id", id, "path", path)
			} else {
				slog.Error("Failed to cache icon image", "notification_id", id, "error", err)
			}
		} else {
			slog.Error("Failed to decode icon_data", "notification_id", id, "error", err)
		}
	}

	if v, ok := hints["image-data"]; ok {
		slog.Debug("Found image-data hint", "notification_id", id)
		if img, err := DecodeDBusImageStruct(v.Value()); err == nil {
			parsed.ImageData = img
			path, err := CacheImage(id, "image", img)
			if err == nil {
				parsed.ImagePath = path
				slog.Debug("Cached image-data", "notification_id", id, "path", path)
			} else {
				slog.Error("Failed to cache image-data", "notification_id", id, "error", err)
			}
		} else {
			slog.Error("Failed to decode image-data", "notification_id", id, "error", err)
		}
	}

	if v, ok := hints["urgency"]; ok {
		if val, ok := ExtractInt(v); ok {
			parsed.Urgency = Urgency(val)
			slog.Debug("Extracted urgency", "notification_id", id, "urgency", val)
		} else {
			slog.Warn("Failed to extract urgency value", "notification_id", id, "value", v.Value())
		}
	}

	if v, ok := hints["sender-pid"]; ok {
		if val, ok := ExtractInt(v); ok {
			parsed.SenderPID = val
			slog.Debug("Extracted sender-pid", "notification_id", id, "pid", val)
		} else {
			slog.Warn("Failed to extract sender-pid value", "notification_id", id, "value", v.Value())
		}
	}

	slog.Debug("Completed parsing hints", "notification_id", id)

	return parsed
}

func ExtractInt(variant dbus.Variant) (uint32, bool) {
	if i, ok := variant.Value().(uint32); ok {
		return i, ok
	}

	v := reflect.ValueOf(variant.Value())
	switch v.Kind() {
	case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64:
		return uint32(v.Int()), true
	case reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64:
		return uint32(v.Uint()), true
	default:
		slog.Error("Variant isn't intger", "variant", variant.Value())
		return 0, false
	}
}
