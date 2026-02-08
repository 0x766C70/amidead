<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>amidead</title>
  <meta name="description" content="Dead man's switch status page">
  <meta name="author" content="vlp">
</head>
<body>
<?php
// Error handling
error_reporting(E_ALL);
ini_set('display_errors', 0); // Don't display errors to users

// Configuration
$logFile = __DIR__ . '/log';

// Validate log file is writable (or directory is writable if file doesn't exist)
if (file_exists($logFile)) {
    if (!is_writable($logFile)) {
        http_response_code(500);
        echo '<p>Error: Log file is not writable.</p>';
        error_log("amidead: Log file is not writable: $logFile");
        exit(1);
    }
} else {
    if (!is_writable(__DIR__)) {
        http_response_code(500);
        echo '<p>Error: Directory is not writable.</p>';
        error_log("amidead: Directory is not writable: " . __DIR__);
        exit(1);
    }
}

// Get current timestamp in ISO 8601 format
$timestamp = date('Y-m-d\TH:i:s');

// Write timestamp to log file with proper error handling
$result = file_put_contents($logFile, $timestamp . "\n", FILE_APPEND | LOCK_EX);

if ($result === false) {
    http_response_code(500);
    echo '<p>Error: Failed to write to log file.</p>';
    error_log("amidead: Failed to write timestamp to log file");
    exit(1);
}

// Success message
http_response_code(200);
echo '<h1>I\'m not dead!</h1>';
echo '<p>Status recorded at: ' . htmlspecialchars($timestamp, ENT_QUOTES, 'UTF-8') . '</p>';
?>
</body>
</html>
