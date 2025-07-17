package main

import (
	"slices"
	"sync"
)

// NotificationList wraps MyDataList with a mutex for concurrency safety
type NotificationList struct {
	mu   sync.Mutex
	del  chan *Notification
	data []*Notification
}

func NewNotificationList(onDelete func(*Notification)) *NotificationList {
	n := &NotificationList{
		data: make([]*Notification, 0),
		del:  make(chan *Notification),
	}
	go func() {
		for n := range n.del {
			if onDelete != nil {
				onDelete(n)
			}
		}
	}()
	return n
}

// Remove removes all entries with the specified ID
func (s *NotificationList) Remove(id uint32) bool {
	s.mu.Lock()
	defer s.mu.Unlock()

	originalLen := len(s.data)
	filtered := s.data[:0]

	for _, d := range s.data {
		if d.ID != id {
			filtered = append(filtered, d)
		} else {
			s.del <- d
		}
	}
	s.data = filtered
	return len(s.data) < originalLen
}

// Filter removes all items not matching the predicate
func (s *NotificationList) Filter(pred func(d *Notification) bool) (bool, int) {
	s.mu.Lock()
	defer s.mu.Unlock()

	originalLen := len(s.data)
	filtered := s.data[:0]

	for _, d := range s.data {
		if pred(d) {
			filtered = append(filtered, d)
		} else {
			s.del <- d
		}
	}
	s.data = filtered

	return len(s.data) < originalLen, len(s.data) - originalLen
}

// Reset clears the list
func (s *NotificationList) Reset() bool {
	s.mu.Lock()
	defer s.mu.Unlock()

	if len(s.data) == 0 {
		return false
	}
	s.data = s.data[:0]
	return true
}

// Add appends a new item (optional utility method)
func (s *NotificationList) Add(n *Notification) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.data = append(s.data, n)
}

// Snapshot returns a copy of the current data (optional for safe reads)
func (s *NotificationList) Snapshot() []*Notification {
	s.mu.Lock()
	defer s.mu.Unlock()
	return slices.Clone(s.data)
}
