INFO() {
    echo 2>&1 "INFO: $@"
}
WARN() {
    echo 2>&1 "WARN: $@"
}
ERROR() {
    echo 2>&1 "ERROR: $@" && exit 1
}

CONFIRM_Y="[Yy]"
CONFIRM_N="[Nn]"
