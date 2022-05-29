from config import Config
from stages import BuildStage, PrepareStage
import asyncio
import logging


async def main():
    config = await Config.create({})
    if config.debug:
        logging.basicConfig(encoding="utf-8", level=logging.DEBUG)
    prepareStage = PrepareStage(config)
    buildStage = BuildStage(config)
    await prepareStage.run()
    # await buildStage.run()


asyncio.run(main())
