import React from 'react';
import { Input } from './input';

interface PhoneInputProps {
  value: string;
  onChange: (value: string) => void;
  maxLength: number;
  placeholder?: string;
  className?: string;
  'aria-label'?: string;
}

export function PhoneInput({
  value,
  onChange,
  maxLength,
  placeholder,
  className,
  'aria-label': ariaLabel,
}: PhoneInputProps) {
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    // Only allow numbers and limit to maxLength
    const numericValue = e.target.value.replace(/\D/g, '').slice(0, maxLength);
    onChange(numericValue);
  };

  return (
    <Input
      type="tel"
      inputMode="numeric"
      pattern="[0-9]*"
      value={value}
      onChange={handleChange}
      maxLength={maxLength}
      placeholder={placeholder}
      className={className}
      aria-label={ariaLabel}
      autoComplete="tel"
    />
  );
} 