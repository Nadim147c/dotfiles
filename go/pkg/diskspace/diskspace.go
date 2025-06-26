package diskspace

import (
	"fmt"
	"math/big"
	"slices"
)

type Diskspace int64

const (
	// Byte-based units
	Zero Diskspace = 0
	Byte Diskspace = 1

	KB Diskspace = 1000 * Byte
	MB Diskspace = 1000 * KB
	GB Diskspace = 1000 * MB
	TB Diskspace = 1000 * GB
	PB Diskspace = 1000 * TB
	EB Diskspace = 1000 * PB

	KiB Diskspace = 1024 * Byte
	MiB Diskspace = 1024 * KiB
	GiB Diskspace = 1024 * MiB
	TiB Diskspace = 1024 * GiB
	PiB Diskspace = 1024 * TiB
	EiB Diskspace = 1024 * PiB

	Kb Diskspace = KB / 8
	Mb Diskspace = MB / 8
	Gb Diskspace = GB / 8
	Tb Diskspace = TB / 8
	Pb Diskspace = PB / 8
	Eb Diskspace = EB / 8

	Kib Diskspace = KiB / 8
	Mib Diskspace = MiB / 8
	Gib Diskspace = GiB / 8
	Tib Diskspace = TiB / 8
	Pib Diskspace = PiB / 8
)

func (d Diskspace) float(div Diskspace) float64 {
	if div == 0 {
		return 0
	}
	abs := d / div
	mod := d % div
	return float64(abs) + float64(mod)/float64(div)
}

// Units contains Diskspace units with the coresponding values
var Units = map[string]Diskspace{
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
func (d Diskspace) Print(precision int, unit string) string {
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
func (d Diskspace) Format(f fmt.State, verb rune) {
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

func (d Diskspace) String() string {
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
	value Diskspace
}

var (
	siBytes     = []pair{{"kB", KB}, {"MB", MB}, {"GB", GB}, {"TB", TB}, {"PB", PB}, {"EB", EB}}
	siBits      = []pair{{"kb", Kb}, {"Mb", Mb}, {"Gb", Gb}, {"Tb", Tb}, {"Pb", Pb}, {"Eb", Eb}}
	binaryBytes = []pair{{"kiB", KiB}, {"MiB", MiB}, {"GiB", GiB}, {"TiB", TiB}, {"PiB", PiB}, {"EiB", EiB}}
	binaryBits  = []pair{{"kib", Kib}, {"Mib", Mib}, {"Gib", Gib}, {"Tib", Tib}, {"Pib", Pib}}
)

func (d Diskspace) findBestUnit(kind string) string {
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
