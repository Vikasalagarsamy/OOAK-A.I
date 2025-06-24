'use client';

import React from 'react';
import { Bell } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover';
import { ScrollArea } from '../scroll-area';
import { useNotifications } from '@/lib/contexts/NotificationContext';
import { cn } from '@/lib/utils';

export function NotificationBell() {
  const { notifications, unreadCount, markAsRead, markAllAsRead } = useNotifications();

  return (
    <Popover>
      <PopoverTrigger asChild>
        <Button 
          variant="ghost" 
          size="sm"
          className="relative h-[44px] w-[44px] flex items-center justify-center"
          aria-label={`Notifications ${unreadCount > 0 ? `(${unreadCount} unread)` : ''}`}
        >
          <Bell className={cn(
            "h-7 w-7 transition-colors duration-200",
            unreadCount > 0 ? "text-red-500" : "text-green-500"
          )} />
          <div className={cn(
            "absolute -top-0.5 -right-0.5 h-3 w-3 rounded-full",
            unreadCount > 0 ? "bg-red-500" : "bg-green-500"
          )} />
          {unreadCount > 0 && (
            <Badge 
              variant="destructive" 
              className="absolute -top-1.5 -right-1.5 h-5 w-5 rounded-full p-0 text-xs flex items-center justify-center"
            >
              {unreadCount}
            </Badge>
          )}
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-80" align="end">
        <div className="flex items-center justify-between mb-4">
          <h4 className="font-medium">Notifications</h4>
          {unreadCount > 0 && (
            <Button 
              variant="ghost" 
              size="sm" 
              onClick={() => markAllAsRead()}
              className="text-xs"
            >
              Mark all as read
            </Button>
          )}
        </div>
        <ScrollArea className="h-[300px]">
          <div className="space-y-2">
            {notifications.length === 0 ? (
              <p className="text-center text-muted-foreground py-4 text-sm">
                No notifications yet
              </p>
            ) : (
              notifications.slice(0, 5).map((notification) => (
                <div
                  key={notification.id}
                  className={cn(
                    "p-3 rounded-lg border text-sm",
                    !notification.is_read && "bg-muted"
                  )}
                >
                  <div className="space-y-1">
                    <p className="font-medium leading-none">
                      {notification.title}
                    </p>
                    <p className="text-xs text-muted-foreground">
                      {notification.message}
                    </p>
                    <div className="flex items-center justify-between gap-2 text-xs text-muted-foreground">
                      <time dateTime={notification.created_at}>
                        {new Date(notification.created_at).toLocaleDateString()}
                      </time>
                      {!notification.is_read && (
                        <Button
                          variant="ghost"
                          size="sm"
                          className="h-6 text-[10px]"
                          onClick={() => markAsRead(notification.id)}
                        >
                          Mark as read
                        </Button>
                      )}
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        </ScrollArea>
      </PopoverContent>
    </Popover>
  );
} 