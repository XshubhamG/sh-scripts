#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if ffmpeg is installed
check_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${RED}Error: ffmpeg is not installed. Please install ffmpeg first.${NC}"
        exit 1
    fi
}

# Function to select input video file
select_video() {
    echo -e "${BLUE}Select input video file:${NC}"
    select video in *.mp4 *.mkv *.avi *.mov; do
        if [ -n "$video" ]; then
            input_video="$video"
            break
        else
            echo -e "${YELLOW}Invalid selection. Please try again.${NC}"
        fi
    done
}

# Function to select subtitle file
select_subtitle() {
    echo -e "${BLUE}Select subtitle file:${NC}"
    select sub in *.srt *.ass *.ssa; do
        if [ -n "$sub" ]; then
            input_subtitle="$sub"
            break
        else
            echo -e "${YELLOW}Invalid selection. Please try again.${NC}"
        fi
    done
}

# Function to get output filename
get_output_filename() {
    # Get the extension of the input video file
    input_extension="${input_video##*.}"

    # Get the base name without extension
    read -p "$(echo -e ${BLUE}"Enter output filename (without extension, default: output): "${NC})" output_base
    output_base=${output_base:-output}

    # Combine base name with the input video's extension
    output_file="${output_base}.${input_extension}"
}

# Main script
clear
echo -e "${GREEN}=== Video Subtitle Adder ===${NC}"
echo

# Check if ffmpeg is installed
check_ffmpeg

# Select input video
select_video
echo -e "${GREEN}Selected video:${NC} $input_video"
echo

# Select subtitle file
select_subtitle
echo -e "${GREEN}Selected subtitle:${NC} $input_subtitle"
echo

# Get output filename
get_output_filename
echo -e "${GREEN}Output will be saved as:${NC} $output_file"
echo

# Confirm before processing
read -p "$(echo -e ${BLUE}"Do you want to proceed? (Y/n): "${NC})" confirm
if [[ $confirm =~ ^[Nn]$ ]]; then
    echo -e "${YELLOW}Operation cancelled.${NC}"
    exit 0
fi

# Process the video
echo -e "${BLUE}Processing video...${NC}"
ffmpeg -i "$input_video" -i "$input_subtitle" -c copy -c:s mov_text -metadata:s:s:0 language=eng "$output_file"

# Check if the process was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Success! Video with subtitles has been created as:${NC} $output_file"
else
    echo -e "${RED}Error: Failed to process the video.${NC}"
    exit 1
fi
