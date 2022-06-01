from deb import Deb
from stages import BuildStage, PrepareStage, ConfigStage
import asyncio
import logging


async def main():
    deb = await Deb.create({})
    if deb.debug:
        logging.basicConfig(encoding="utf-8", level=logging.DEBUG)
    prepareStage = PrepareStage(deb)
    configStage = ConfigStage(deb)
    buildStage = BuildStage(deb)
    logging.debug("STAGE: running prepare...")
    await prepareStage.run()
    logging.debug("STAGE: completed prepare")
    logging.debug("STAGE: running config...")
    await configStage.run()
    logging.debug("STAGE: completed config")
    logging.debug("STAGE: running build...")
    await buildStage.run()
    logging.debug("STAGE: completed build")


asyncio.run(main())
