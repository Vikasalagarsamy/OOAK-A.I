'use client';

import * as React from 'react';
import { Check, ChevronsUpDown } from 'lucide-react';
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import {
  Popover,
  PopoverContent,
  PopoverTrigger,
} from '@/components/ui/popover';

// Country data with codes and validation rules
const countries = [
  { 
    name: 'India', 
    code: '+91', 
    flag: '🇮🇳',
    minLength: 10,
    maxLength: 10,
    pattern: /^[6-9]\d{9}$/, // Starts with 6-9 followed by 9 digits
    example: "9876543210"
  },
  { 
    name: 'United States', 
    code: '+1', 
    flag: '🇺🇸',
    minLength: 10,
    maxLength: 10,
    pattern: /^\d{10}$/, // 10 digits
    example: "2345678901"
  },
  { 
    name: 'United Kingdom', 
    code: '+44', 
    flag: '🇬🇧',
    minLength: 10,
    maxLength: 10,
    pattern: /^[1-9]\d{9}$/, // Starts with 1-9 followed by 9 digits
    example: "7123456789"
  },
  { 
    name: 'Canada', 
    code: '+1', 
    flag: '🇨🇦',
    minLength: 10,
    maxLength: 10,
    pattern: /^\d{10}$/, // 10 digits
    example: "2345678901"
  },
  { 
    name: 'Australia', 
    code: '+61', 
    flag: '🇦🇺',
    minLength: 9,
    maxLength: 9,
    pattern: /^[1-9]\d{8}$/, // Starts with 1-9 followed by 8 digits
    example: "212345678"
  },
  { 
    name: 'Singapore', 
    code: '+65', 
    flag: '🇸🇬',
    minLength: 8,
    maxLength: 8,
    pattern: /^[689]\d{7}$/, // Starts with 6,8,9 followed by 7 digits
    example: "81234567"
  },
  { 
    name: 'Malaysia', 
    code: '+60', 
    flag: '🇲🇾',
    minLength: 9,
    maxLength: 10,
    pattern: /^[1-9]\d{8,9}$/, // 9-10 digits starting with 1-9
    example: "123456789"
  },
  { 
    name: 'United Arab Emirates', 
    code: '+971', 
    flag: '🇦🇪',
    minLength: 9,
    maxLength: 9,
    pattern: /^[2-9]\d{8}$/, // Starts with 2-9 followed by 8 digits
    example: "501234567"
  },
  { 
    name: 'Saudi Arabia', 
    code: '+966', 
    flag: '🇸🇦',
    minLength: 9,
    maxLength: 9,
    pattern: /^[1-9]\d{8}$/, // 9 digits starting with 1-9
    example: "512345678"
  },
].sort((a, b) => a.name.localeCompare(b.name));

export type CountrySelectProps = {
  value?: string;
  onChange?: (value: string) => void;
  onValidationChange?: (isValid: boolean) => void;
  phoneNumber?: string;
};

export function CountrySelect({ value, onChange, onValidationChange, phoneNumber }: CountrySelectProps) {
  const [open, setOpen] = React.useState(false);
  const [selectedCountry, setSelectedCountry] = React.useState(countries[0]);

  React.useEffect(() => {
    if (value) {
      const country = countries.find((c) => c.code === value);
      if (country) {
        setSelectedCountry(country);
      }
    }
  }, [value]);

  React.useEffect(() => {
    if (phoneNumber && onValidationChange) {
      const isValid = validatePhoneNumber(phoneNumber, selectedCountry);
      onValidationChange(isValid);
    }
  }, [phoneNumber, selectedCountry, onValidationChange]);

  const validatePhoneNumber = (phone: string, country: typeof countries[0]): boolean => {
    if (!phone) return false;
    
    // Remove any non-digit characters
    const cleaned = phone.replace(/\D/g, '');
    
    // Check length
    if (cleaned.length < country.minLength || cleaned.length > country.maxLength) {
      return false;
    }
    
    // Check pattern
    return country.pattern.test(cleaned);
  };

  return (
    <Popover open={open} onOpenChange={setOpen}>
      <PopoverTrigger asChild>
        <Button
          variant="outline"
          role="combobox"
          aria-expanded={open}
          aria-label="Select a country"
          className="w-[120px] justify-between"
        >
          <div className="flex items-center gap-2">
            <span className="text-xl">{selectedCountry.flag}</span>
            <span className="font-medium text-sm">{selectedCountry.code}</span>
          </div>
          <ChevronsUpDown className="ml-1 h-4 w-4 shrink-0 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent className="w-[280px] p-0">
        <div className="max-h-[300px] overflow-y-auto">
          {countries.map((country) => (
            <div
              key={country.code}
              className={cn(
                'flex items-center gap-2 px-4 py-2 cursor-pointer hover:bg-accent hover:text-accent-foreground',
                selectedCountry.code === country.code && 'bg-accent'
              )}
              onClick={() => {
                setSelectedCountry(country);
                onChange?.(country.code);
                setOpen(false);
              }}
            >
              <span className="text-xl">{country.flag}</span>
              <div className="flex flex-col flex-1">
                <span className="font-medium">{country.name}</span>
                <span className="text-sm text-muted-foreground">
                  {country.code} • {country.minLength} digits
                </span>
              </div>
              {selectedCountry.code === country.code && (
                <Check className="h-4 w-4" />
              )}
            </div>
          ))}
        </div>
      </PopoverContent>
    </Popover>
  );
} 