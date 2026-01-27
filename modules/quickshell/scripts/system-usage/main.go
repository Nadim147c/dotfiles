package main

import (
	"encoding/json"
	"fmt"
	"maps"
	"os"
	"reflect"
	"slices"
	"strings"
	"time"
)

func StructValueStringMap(prefix string, v any) map[string]any {
	rv := reflect.ValueOf(v)
	if rv.Kind() == reflect.Pointer {
		rv = rv.Elem()
	}
	if rv.Kind() != reflect.Struct {
		return nil
	}

	rt := rv.Type()
	out := make(map[string]any, rt.NumField()*2)

	for i := 0; i < rt.NumField(); i++ {
		fieldType := rt.Field(i)
		fieldVal := rv.Field(i)

		// exported fields only
		if !fieldType.IsExported() {
			continue
		}

		// Skip zero-value embedded structs, optional
		if fieldVal.Kind() == reflect.Struct && fieldType.Anonymous {
			continue
		}

		literalTypes := []reflect.Kind{
			reflect.String,
			reflect.Bool,
			reflect.Int,
			reflect.Int8,
			reflect.Int16,
			reflect.Int32,
			reflect.Int64,
			reflect.Uint,
			reflect.Uint8,
			reflect.Uint16,
			reflect.Uint32,
			reflect.Uint64,
			reflect.Float32,
			reflect.Float64,
		}
		if slices.Contains(literalTypes, fieldVal.Kind()) {
			out[prefix+fieldType.Name] = fieldVal.Interface()
		}

		stringMethod := fieldVal.MethodByName("String")

		if !stringMethod.IsValid() {
			if fieldVal.Kind() == reflect.Float64 {
				key := fieldType.Name
				out[prefix+key+"String"] = formatFloat(fieldVal.Float())
			}
			continue // opt-in only
		}

		// Call String()
		stringRes := stringMethod.Call(nil)
		if len(stringRes) != 1 || stringRes[0].Kind() != reflect.String {
			return nil
		}

		key := fieldType.Name
		out[prefix+key+"String"] = stringRes[0].Interface()
	}

	return out
}

func formatFloat(n float64) string {
	s := fmt.Sprintf("%.2f", n)
	s = strings.TrimRight(s, "0")
	s = strings.TrimRight(s, ".")
	return s
}

const UpdateTime = time.Second / 4

func main() {
	netSpeed := NewNetSpeedCalculator()
	ticker := time.NewTicker(UpdateTime)
	defer ticker.Stop()

	encoder := json.NewEncoder(os.Stdout)

	for range ticker.C {
		stats := map[string]any{}

		netState := netSpeed.Update()
		maps.Copy(stats, StructValueStringMap("net", netState))
		memState := GetMemState()
		maps.Copy(stats, StructValueStringMap("mem", memState))
		cpuState := GetCPUState()
		maps.Copy(stats, StructValueStringMap("cpu", cpuState))

		encoder.Encode(stats)
	}
}
