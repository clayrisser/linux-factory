from config import Config
from stages import BuildStage, PrepareStage
import asyncio


async def main():
    config = await Config.create(
        {"debug": False, "overlays": {"brave": {"chip": "chop"}}}
    )
    prepareStage = PrepareStage(config)
    buildStage = BuildStage(config)
    await prepareStage.run()
    # await buildStage.run()


asyncio.run(main())
