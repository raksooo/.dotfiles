#!/bin/bash
# Default acpi script that takes an entry for all actions

case "$1" in
    button/power)
        case "$2" in
            PBTN|PWRF)
                logger 'PowerButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SLPB|SBTN)
                logger 'SleepButton pressed'
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000)
                        logger 'AC unpluged'
                        ;;
                    00000001)
                        logger 'AC pluged'
                        ;;
                esac
                ;;
            *)
                logger "ACPI action undefined: $2"
                ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)
                        logger 'Battery online'
                        ;;
                    00000001)
                        logger 'Battery offline'
                        ;;
                esac
                ;;
            CPU0)
                ;;
            *)  logger "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        EXCEPTION="vim\|ssh"
        case "$3" in
            close)
                #su oskar -c "export DISPLAY=:0 && xset dpms force off && lock"
                #suspendUser suspend oskar $EXCEPTION
                #(
                #    sleep $[30 * 60]
                #    rm /tmp/suspendPid
                #    suspendUser resume oskar $EXCEPTION
                #    systemctl suspend
                #) &
                #echo $! >> /tmp/suspendPid
                ;;
            open)
                #if [ -f /tmp/suspendPid ]; then
                #    suspendUser resume oskar $EXCEPTION
                #    rm /tmp/suspendPid
                #fi
                #su oskar -c "xset -display :0 dpms force on"
                #su oskar -c "awesome-client \"textclock._private.textclock_update_cb()\""
                ;;
            *)
                logger "ACPI action undefined: $3"
                ;;
    esac
    ;;
    *)
        logger "ACPI group/action undefined: $1 / $2"
        ;;
esac

# vim:set ts=4 sw=4 ft=sh et:
