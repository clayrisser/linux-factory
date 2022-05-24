from stages import BuildStage, PrepareStage
import asyncio


async def main():
    prepareStage = PrepareStage()
    buildStage = BuildStage()
    await prepareStage.run()
    await buildStage.run()


asyncio.run(main())
