#!/usr/bin/env python
# -*- coding: utf-8 -*-
# vim: ai ts=4 sts=4 et sw=4 nu


"""
    https://github.com/sametmax/Bat-belt/blob/master/batbelt/parallel.py
"""

import threading
import multiprocessing
from functools import wraps
from Queue import Empty


class StopWorker():
    pass


def worker(block=True, timeout=0.1, method='process'):
    """
        Turn a function into a worker:

            from parallel import worker

            @worker()
            def test(mot):
                print "in %s" % mot
                return mot

            process = test.start()

            for x in range(10):
            process.put(x)

            for x in range(10):
            print "out %s" % process.get()

            process.stop()

        Which outputs:

            in 0
            out 0
            in 1
            in 2
            out 1
            in 3
            out 2
            in 4
            out 3
            out 4
            in 5
            out 5
            in 6
            out 6
            in 7
            out 7
            in 8
            out 8
            in 9
            out 9
    """

    def decorator(func):

        if method == 'thread':
            Queue = threading.Queue
            Manager = threading.Thread
            Error = threading.TimeoutError
        else:
            Queue = multiprocessing.Queue
            Manager = multiprocessing.Process
            Error = multiprocessing.TimeoutError

            in_queue = Queue()
            out_queue = Queue()

            def main_loop():

                while True:
                    try:

                        res = in_queue.get(block, timeout)

                        if isinstance(res, StopWorker):
                            break

                        out_queue.put(func(res))

                    except (Error, Empty):
                        pass
                    except (StopWorker, KeyboardInterrupt):
                        break
                    except Exception as e:
                        out_queue.put(e)

            @wraps(func)
            def wrapper(*args, **kwargs):
                return func(*args, **kwargs)

            wrapper.manager = Manager(target=main_loop)
            wrapper.manager.stop = lambda: in_queue.put(StopWorker(), block, timeout)
            wrapper.manager.put = lambda x: in_queue.put(x, block, timeout)
            wrapper.manager.get = lambda b=block, t=timeout: out_queue.get(b, t)
            wrapper.TimeoutError = Error
            wrapper.start = lambda: wrapper.manager.start() or wrapper.manager

            return wrapper

    return decorator
