package log

import (
	"context"
	"log/slog"
	"os"
	"time"

	"github.com/MatusOllah/slogcolor"
	"github.com/fatih/color"
)

type discardHandler struct{}

func (h *discardHandler) Enabled(_ context.Context, _ slog.Level) bool  { return false }
func (h *discardHandler) Handle(_ context.Context, _ slog.Record) error { return nil }
func (h *discardHandler) WithAttrs(_ []slog.Attr) slog.Handler          { return h }
func (h *discardHandler) WithGroup(_ string) slog.Handler               { return h }

func Setup(level slog.Level) {
	if level > slog.LevelError {
		slog.SetDefault(slog.New(&discardHandler{}))
		return
	}

	opts := slogcolor.DefaultOptions
	opts.Level = level
	opts.TimeFormat = time.Kitchen
	opts.SrcFileMode = 0
	opts.LevelTags = map[slog.Level]string{
		slog.LevelDebug: color.New(color.FgGreen).Sprint("DBG"),
		slog.LevelInfo:  color.New(color.FgCyan).Sprint("INF"),
		slog.LevelWarn:  color.New(color.FgYellow).Sprint("WRN"),
		slog.LevelError: color.New(color.FgRed).Sprint("ERR"),
	}

	slog.SetDefault(slog.New(slogcolor.NewHandler(os.Stderr, opts)))
}
