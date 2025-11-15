package main

import (
	"fmt"
	"math/big"
	"slices"
)

type Datasize int64

const (
	// Byte-based units
	Zero Datasize = 0
	Byte Datasize = 1

	KB Datasize = 1000 * Byte
	MB Datasize = 1000 * KB
	GB Datasize = 1000 * MB
	TB Datasize = 1000 * GB
	PB Datasize = 1000 * TB
	EB Datasize = 1000 * PB

	KiB Datasize = 1024 * Byte
	MiB Datasize = 1024 * KiB
	GiB Datasize = 1024 * MiB
	TiB Datasize = 1024 * GiB
	PiB Datasize = 1024 * TiB
	EiB Datasize = 1024 * PiB

	Kb Datasize = KB / 8
	Mb Datasize = MB / 8
	Gb Datasize = GB / 8
	Tb Datasize = TB / 8
	Pb Datasize = PB / 8
	Eb Datasize = EB / 8

	Kib Datasize = KiB / 8
	Mib Datasize = MiB / 8
	Gib Datasize = GiB / 8
	Tib Datasize = TiB / 8
	Pib Datasize = PiB / 8
)

func (d Datasize) float(div Datasize) float64 {
	if div == 0 {
		return 0
	}
	abs := d / div
	mod := d % div
	return float64(abs) + float64(mod)/float64(div)
}

// Units contains Diskspace units with the coresponding values
var Units = map[string]Datasize{
	"kB": KB, "KB": KB, "MB": MB, "GB": GB, "TB": TB, "PB": PB, "EB": EB,
	"kiB": KiB, "KiB": KiB, "MiB": MiB, "GiB": GiB, "TiB": TiB, "PiB": PiB, "EiB": EiB,
	"kb": Kb, "Kb": Kb, "Mb": Mb, "Gb": Gb, "Tb": Tb, "Pb": Pb, "Eb": Eb,
	"kib": Kib, "Kib": Kib, "Mib": Mib, "Gib": Gib, "Tib": Tib, "Pib": Pib,
}

// Print the Diskspace in given unit and precision
// Supported units:
//   - b, B
//   - kB, KB, MB, GB, TB, PB, EB,
//   - kiB, KiB, MiB, GiB, TiB, PiB, EiB,
//   - kb, Kb, Mb, Gb, Tb, Pb, Eb,
//   - kib, Kib, Mib, Gib, Tib, Pib, Eib,
func (d Datasize) Print(precision int, unit string) string {
	// Handle bytes
	if unit == "B" {
		if precision == 0 {
			return fmt.Sprintf("%d %s", int64(d), unit)
		}
		// For bytes with precision, show as X.000... B
		return fmt.Sprintf("%d.%0*d %s", int64(d), precision, 0, unit)
	}

	// Handle bits (convert bytes to bits by multiplying by 8)
	if unit == "b" {
		bits := big.NewInt(int64(d))
		bits.Mul(bits, big.NewInt(8))

		if precision == 0 {
			return fmt.Sprintf("%s %s", bits, unit)
		}
		// For bits with precision, show as X.000... b
		return fmt.Sprintf("%s.%0*d %s", bits, precision, 0, unit)
	}

	u, ok := Units[unit]
	if !ok {
		panic("illegal diskspace unit")
	}

	format := fmt.Sprintf("%%.%df %s", precision, unit)
	return fmt.Sprintf(format, d.float(u))
}

// Format formats Diskspace. You can use these following formats:
//   - %K for binary byte (KiB, MiB...)
//   - %k for binary bit (Kib, Mib...)
//   - %B for si byte (KB, MB...)
//   - %b for si bit (Kb, Mb...)
//   - %d for int64
//   - %s is similar to binary byte but ignores precision
func (d Datasize) Format(f fmt.State, verb rune) {
	precision, fixed := f.Precision()
	var unit string
	switch verb {
	case 'B':
		unit = d.findBestUnit("binary-byte")
	case 'b':
		unit = d.findBestUnit("binary-bit")
	case 'M':
		unit = d.findBestUnit("si-byte")
	case 'm':
		unit = d.findBestUnit("si-bit")
	case 'd':
		fmt.Fprint(f, int64(d))
		return
	default:
		fmt.Fprint(f, d.String())
		return
	}

	if fixed {
		fmt.Fprint(f, d.Print(precision, unit))
		return
	}

	if unit == "B" || unit == "b" {
		fmt.Fprint(f, d.Print(0, unit))
		return
	}

	fmt.Fprint(f, d.Print(2, unit))
}

func (d Datasize) String() string {
	unit := d.findBestUnit("binary-byte")
	switch unit {
	case "b", "B":
		return d.Print(0, unit)
	default:
		return d.Print(2, unit)
	}
}

type pair struct {
	name  string
	value Datasize
}

var (
	siBytes     = []pair{{"kB", KB}, {"MB", MB}, {"GB", GB}, {"TB", TB}, {"PB", PB}, {"EB", EB}}
	siBits      = []pair{{"kb", Kb}, {"Mb", Mb}, {"Gb", Gb}, {"Tb", Tb}, {"Pb", Pb}, {"Eb", Eb}}
	binaryBytes = []pair{
		{"kiB", KiB},
		{"MiB", MiB},
		{"GiB", GiB},
		{"TiB", TiB},
		{"PiB", PiB},
		{"EiB", EiB},
	}
	binaryBits = []pair{{"kib", Kib}, {"Mib", Mib}, {"Gib", Gib}, {"Tib", Tib}, {"Pib", Pib}}
)

func (d Datasize) findBestUnit(kind string) string {
	var unit string
	var unitList []pair
	switch kind {
	case "si", "si-byte":
		unit = "B"
		unitList = siBytes
	case "si-bit":
		unit = "b"
		unitList = siBits
	case "binary", "binary-byte":
		unit = "B"
		unitList = binaryBytes
	case "binary-bit":
		unit = "b"
		unitList = siBits
	default:
		panic("invalid unit kind")
	}

	for v := range slices.Values(unitList) {
		if v.value < d {
			unit = v.name
		} else {
			return unit
		}
	}
	return unit
}
