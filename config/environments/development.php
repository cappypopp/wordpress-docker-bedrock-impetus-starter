<?php

/**
 * Configuration overrides for WP_ENV === 'development'
 */

use Roots\WPConfig\Config;

use function Env\env;

Config::define('SAVEQUERIES', true);
Config::define('WP_DEBUG', true);
Config::define('WP_DEBUG_DISPLAY', true);
Config::define('WP_DEBUG_LOG', env('WP_DEBUG_LOG') ?? true);
Config::define('WP_DISABLE_FATAL_ERROR_HANDLER', true);
Config::define('SCRIPT_DEBUG', true);
Config::define('DISALLOW_INDEXING', true);

ini_set('display_errors', '1');

// Enable plugin and theme updates and installation from the admin
Config::define('DISALLOW_FILE_MODS', false);

/**
 * Debug Log Rotation
 */
$debug_log = env('WP_DEBUG_LOG_PATH') ? env('WP_DEBUG_LOG_PATH') : dirname(ABSPATH) . '/web/app/debug.log';
$max_log_size = env('WP_DEBUG_LOG_MAX_SIZE') ? (int)env('WP_DEBUG_LOG_MAX_SIZE') * 1024 * 1024 : 20 * 1024 * 1024; // Default 20MB
$max_backup_age = env('WP_DEBUG_LOG_MAX_AGE') ? (int)env('WP_DEBUG_LOG_MAX_AGE') : 30; // Default 30 days

// Rotate log if it exceeds size limit
if (file_exists($debug_log) && filesize($debug_log) > $max_log_size) {
    try {
        $backup_log = $debug_log . '-' . date('Y-m-d_H-i-s') . '.log';
        if (!rename($debug_log, $backup_log)) {
            error_log('Failed to rotate debug log: Could not rename file');
        } else {
            if (!file_put_contents($debug_log, '')) {
                error_log('Failed to rotate debug log: Could not create new log file');
            }
        }
    } catch (Exception $e) {
        error_log('Debug log rotation failed: ' . $e->getMessage());
    }
}

// Clean up old backup logs
try {
    $backup_files = glob($debug_log . '-*.log');
    $now = time();

    foreach ($backup_files as $file) {
        if (filemtime($file) < ($now - ($max_backup_age * 24 * 60 * 60))) {
            if (!unlink($file)) {
                error_log('Failed to delete old debug log: ' . $file);
            }
        }
    }
} catch (Exception $e) {
    error_log('Debug log cleanup failed: ' . $e->getMessage());
}
