#!/usr/bin/perl

use strict;
use warnings;

use constant HIDIOCGRAWINFO         => 2148026371;
use constant BUS_BLUETOOTH          =>          5;
use constant HID_VENDOR_ID_LOGITECH =>       1133;
use constant HID_DEVICE_ID_K760     =>     -19690;
use constant HID_DEVICE_ID_K760_ALT =>     -19688;
use constant HID_DEVICE_ID_K810     =>     -19687;

my %message = (
    HID_DEVICE_ID_K760() => {
        on   => (pack "C*", 0x10, 0xff, 0x05, 0x14, 0x00, 0x00, 0x00),
        off  => (pack "C*", 0x10, 0xff, 0x05, 0x14, 0x01, 0x00, 0x00),
    },
    HID_DEVICE_ID_K760_ALT() => {
        on   => (pack "C*", 0x10, 0xff, 0x05, 0x14, 0x00, 0x00, 0x00),
        off  => (pack "C*", 0x10, 0xff, 0x05, 0x14, 0x01, 0x00, 0x00),
    },
    HID_DEVICE_ID_K810() => {
        on   => (pack "C*", 0x10, 0xff, 0x06, 0x15, 0x00, 0x00, 0x00),
        off  => (pack "C*", 0x10, 0xff, 0x06, 0x15, 0x01, 0x00, 0x00),
    },
);

#die
#   "usage: $0 [on|off]\n",
#   "\ton  makes the media keys the default\n",
#   "\toff makes the function keys the default\n"
#unless @ARGV == 1 and my ($choice) = $ARGV[0] =~ /^(on|off)$/;
my ($choice) = @ARGV ? $ARGV[0] =~ /^(on|off)$/ : "off";

my $device;

# find the first device we can set the option on
# TODO: add a parameter to directly specify a device
# TODO: add a parameter to make it set all devices
FILE_SEARCH:
for my $file (</sys/class/hidraw/hidraw*/device/uevent>) {
    open my $fh, "<", $file or do {
        warn "could not open $file: $!\n";
        next;
    };

    while (<$fh>) {
        if (/HID_NAME=Logitech K(76|81)0/) {
            my ($hid_raw_name) = $file =~ m{(hidraw[^/]+)};
            $device = "/dev/$hid_raw_name";
            last FILE_SEARCH;
        }
    }
}

die "sorry, could not find a suported device on your machine\n" unless $device;

# re-exec with sudo if we can't open the device
unless (-r $device and -w $device) {
    # unless we are already root
    exec "sudo", $^X, $0, @ARGV unless $> == 0;
}

open my $dev, "+<", $device or die "could not open device $device: $!\n";

my $success = ioctl $dev, HIDIOCGRAWINFO, my $struct = "";

die "could not determine if $device is supported\n" unless $success;

my ($bus_type, $vendor, $product) = unpack "Lss", $struct;

die "detected device $device is not a Bluetooth device\n"
    unless $bus_type == BUS_BLUETOOTH;

die "detected device $device is not a Logitech product\n"
    unless $vendor == HID_VENDOR_ID_LOGITECH;

die "detected device $device is not a supported product\n"
    unless exists $message{$product};

syswrite $dev, $message{$product}{$choice};

close $dev;
