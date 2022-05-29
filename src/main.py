from deb import Deb
from stages import BuildStage, PrepareStage
import asyncio
import logging


async def main():
    deb = await Deb.create({})
    if deb.debug:
        logging.basicConfig(encoding="utf-8", level=logging.DEBUG)
    prepareStage = PrepareStage(deb)
    buildStage = BuildStage(deb)
    await prepareStage.run()
    # await buildStage.run()


asyncio.run(main())
