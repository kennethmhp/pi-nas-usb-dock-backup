import sys
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BOARD)
GPIO.setwarnings(False)

if sys.argv[1] == 'on':
        GPIO.setup(12, GPIO.OUT,initial=GPIO.HIGH)
        GPIO.output(12, 0)
if sys.argv[1] == 'off':
        GPIO.setup(12, GPIO.OUT,initial=GPIO.LOW)
        GPIO.output(12, 1)
        GPIO.cleanup()
exit()
