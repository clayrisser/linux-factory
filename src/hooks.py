import inspect


class Hooks:
    _hooks = {}

    def listen(self, name, cb):
        if name not in self._hooks:
            self._hooks[name] = []
        self._hooks[name].append(cb)

    async def trigger(self, name, args=[]):
        if name not in self._hooks or not self._hooks[name]:
            return
        for cb in self._hooks[name]:
            if inspect.iscoroutinefunction(cb):
                await cb(*args)
            else:
                cb(*args)
