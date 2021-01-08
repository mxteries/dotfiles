import time


ON = 30
OFF = 5
OFF_LONG = 40


def timer(minutes):
    seconds = minutes * 60

    while seconds >= 0:
        m, s = divmod(seconds, 60)
        if s < 10:
            s = '0{}'.format(s)

        print('TIME TO TIP THE SCALES {0}:{1} remaining'.format(m, s), end='\r', flush=True)
        seconds -= 1
        time.sleep(1)
    print('\n')


print('### POMODORO ###')
on_count = 1
off_count = 1

while True:
    print('ON #{0}'.format(on_count))
    timer(ON)
    on_count += 1

    print('OFF #{0}'.format(off_count))
    if off_count % 3 == 0:
        timer(OFF_LONG)
    else:
        timer(OFF)
    off_count +=1
