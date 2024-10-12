#!/bin/bash

# Define the directory containing the docker-compose projects
DOCKER_PROJECTS_DIR="/data/docker"

# Function to check if a service is disabled
is_disabled() {
    [ -f "$1/.disabled" ]
}

# Function to start all services
start_all() {
    for dir in "$DOCKER_PROJECTS_DIR"/*/; do
        if ! is_disabled "$dir"; then
            echo "Starting services in $dir"
            (cd "$dir" && docker compose up -d)
        else
            echo "Skipping disabled service in $dir"
        fi
    done
}

# Function to stop all services
stop_all() {
    for dir in "$DOCKER_PROJECTS_DIR"/*/; do
        if ! is_disabled "$dir"; then
            echo "Stopping services in $dir"
            (cd "$dir" && docker compose down)
        else
            echo "Skipping disabled service in $dir"
        fi
    done
}

# Function to start specific services
start_specific() {
    for service in "$@"; do
        if [ -d "$DOCKER_PROJECTS_DIR/$service" ]; then
            if ! is_disabled "$DOCKER_PROJECTS_DIR/$service"; then
                echo "Starting services in $DOCKER_PROJECTS_DIR/$service"
                (cd "$DOCKER_PROJECTS_DIR/$service" && docker compose up -d)
            else
                echo "Skipping disabled service in $DOCKER_PROJECTS_DIR/$service"
            fi
        else
            echo "Directory $DOCKER_PROJECTS_DIR/$service does not exist"
        fi
    done
}

# Function to stop specific services
stop_specific() {
    for service in "$@"; do
        if [ -d "$DOCKER_PROJECTS_DIR/$service" ]; then
            if ! is_disabled "$DOCKER_PROJECTS_DIR/$service"; then
                echo "Stopping services in $DOCKER_PROJECTS_DIR/$service"
                (cd "$DOCKER_PROJECTS_DIR/$service" && docker compose down)
            else
                echo "Skipping disabled service in $DOCKER_PROJECTS_DIR/$service"
            fi
        else
            echo "Directory $DOCKER_PROJECTS_DIR/$service does not exist"
        fi
    done
}

# Function to tail logs of specific services
tail_logs() {
    for service in "$@"; do
        if [ -d "$DOCKER_PROJECTS_DIR/$service" ]; then
            if ! is_disabled "$DOCKER_PROJECTS_DIR/$service"; then
                echo "Tailing logs for $DOCKER_PROJECTS_DIR/$service"
                (cd "$DOCKER_PROJECTS_DIR/$service" && docker compose logs -f)
            else
                echo "Skipping disabled service in $DOCKER_PROJECTS_DIR/$service"
            fi
        else
            echo "Directory $DOCKER_PROJECTS_DIR/$service does not exist"
        fi
    done
}

# Function to disable a service
disable_service() {
    for service in "$@"; do
        if [ -d "$DOCKER_PROJECTS_DIR/$service" ]; then
            echo "Disabling service in $DOCKER_PROJECTS_DIR/$service"
            touch "$DOCKER_PROJECTS_DIR/$service/.disabled"
        else
            echo "Directory $DOCKER_PROJECTS_DIR/$service does not exist"
        fi
    done
}

# Function to enable a service
enable_service() {
    for service in "$@"; do
        if [ -d "$DOCKER_PROJECTS_DIR/$service" ]; then
            if is_disabled "$DOCKER_PROJECTS_DIR/$service"; then
                echo "Enabling service in $DOCKER_PROJECTS_DIR/$service"
                rm "$DOCKER_PROJECTS_DIR/$service/.disabled"
            else
                echo "Service in $DOCKER_PROJECTS_DIR/$service is not disabled"
            fi
        else
            echo "Directory $DOCKER_PROJECTS_DIR/$service does not exist"
        fi
    done
}

# Main script logic
case "$1" in
    start-all)
        start_all
        ;;
    stop-all)
        stop_all
        ;;
    start)
        shift
        start_specific "$@"
        ;;
    stop)
        shift
        stop_specific "$@"
        ;;
    logs)
        shift
        tail_logs "$@"
        ;;
    disable)
        shift
        disable_service "$@"
        ;;
    enable)
        shift
        enable_service "$@"
        ;;
    *)
        echo "Usage: $0 {start-all|stop-all|start|stop|logs|disable|enable} [service...]"
        ;;
esac
