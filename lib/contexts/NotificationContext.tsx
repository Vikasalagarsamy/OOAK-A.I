'use client';

import React, { createContext, useContext, useEffect, useState } from 'react';
import { toast } from 'sonner';

export interface Notification {
  id: string;
  type: string;
  priority: string;
  title: string;
  message: string;
  quotation_id?: number;
  is_read: boolean;
  created_at: string;
  expires_at?: string;
  action_url?: string;
  action_label?: string;
  metadata?: Record<string, any>;
  scheduled_for?: string;
  ai_enhanced?: boolean;
  recipient_role?: string;
  recipient_id?: number;
  data?: Record<string, any>;
  read_at?: string;
  target_user?: string;
  employee_id?: number;
}

interface NotificationContextType {
  notifications: Notification[];
  unreadCount: number;
  markAsRead: (id: string) => Promise<void>;
  markAllAsRead: () => Promise<void>;
  isDrawerOpen: boolean;
  setIsDrawerOpen: (open: boolean) => void;
}

const NotificationContext = createContext<NotificationContextType | undefined>(undefined);

export function NotificationProvider({ children }: { children: React.ReactNode }) {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [lastFetchTime, setLastFetchTime] = useState<string | null>(null);

  // Fetch notifications
  const fetchNotifications = async () => {
    try {
      const queryParams = new URLSearchParams();
      if (lastFetchTime) {
        queryParams.append('after', lastFetchTime);
      }

      const response = await fetch(`/api/notifications?${queryParams.toString()}`);
      if (!response.ok) throw new Error('Failed to fetch notifications');
      
      const data = await response.json();
      
      if (data.notifications.length > 0) {
        setNotifications(prev => {
          const newNotifications = [...data.notifications, ...prev];
          // Keep only unique notifications based on ID
          return Array.from(new Map(newNotifications.map(n => [n.id, n])).values())
            .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime())
            .slice(0, 50); // Keep last 50 notifications
        });

        // Show toast for new notifications
        data.notifications.forEach((notification: Notification) => {
          if (!notification.is_read) {
            toast(notification.title, {
              description: notification.message,
              action: {
                label: "View",
                onClick: () => setIsDrawerOpen(true)
              },
              duration: 5000,
            });
          }
        });

        // Update last fetch time
        const latestNotification = data.notifications[0];
        if (latestNotification) {
          setLastFetchTime(latestNotification.created_at);
        }
      }

      // Update unread count
      setUnreadCount(data.unreadCount);

    } catch (error) {
      console.error('Error fetching notifications:', error);
    }
  };

  // Initial fetch and polling
  useEffect(() => {
    fetchNotifications();
    
    // Poll every 30 seconds
    const interval = setInterval(fetchNotifications, 30000);
    
    return () => clearInterval(interval);
  }, []);

  // Mark single notification as read
  const markAsRead = async (id: string) => {
    try {
      const response = await fetch(`/api/notifications/${id}/read`, {
        method: 'POST',
      });
      
      if (!response.ok) throw new Error('Failed to mark notification as read');
      
      setNotifications(prev => 
        prev.map(n => n.id === id ? { ...n, is_read: true, read_at: new Date().toISOString() } : n)
      );
      setUnreadCount(prev => Math.max(0, prev - 1));
    } catch (error) {
      console.error('Error marking notification as read:', error);
    }
  };

  // Mark all notifications as read
  const markAllAsRead = async () => {
    try {
      const response = await fetch('/api/notifications/read-all', {
        method: 'POST',
      });
      
      if (!response.ok) throw new Error('Failed to mark all notifications as read');
      
      setNotifications(prev => 
        prev.map(n => ({ ...n, is_read: true, read_at: new Date().toISOString() }))
      );
      setUnreadCount(0);
    } catch (error) {
      console.error('Error marking all notifications as read:', error);
    }
  };

  return (
    <NotificationContext.Provider 
      value={{ 
        notifications, 
        unreadCount, 
        markAsRead, 
        markAllAsRead,
        isDrawerOpen,
        setIsDrawerOpen
      }}
    >
      {children}
    </NotificationContext.Provider>
  );
}

export function useNotifications() {
  const context = useContext(NotificationContext);
  if (context === undefined) {
    throw new Error('useNotifications must be used within a NotificationProvider');
  }
  return context;
} 