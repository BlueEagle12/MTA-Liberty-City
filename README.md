# MTA-Liberty-City

A full **Grand Theft Auto III: Liberty City** map conversion for **Multi Theft Auto: San Andreas (MTA:SA)**.

This project brings the gritty, urban world of **GTA: Liberty City** into the MTA:SA engine - complete with buildings, roads, bridges, islands, and environmental props.

Whether you're recreating classic missions or developing entirely new gamemodes in the familiar streets of Portland, Staunton Island, or Shoreside Vale, this resource provides a solid foundation for your server.

---

## Features

* Full **Liberty City** map ported into MTA:SA
* Includes all three islands: Portland, Staunton Island, and Shoreside Vale
* Water map conversion
* Custom radar support through Radar_Core
* Assets are packed using IMG containers for faster loading and downloading
* Optimized for performance and EagleLoader integration

---

## Requirements

This resource requires the following resources:

* **[EagleLoader](https://github.com/BlueEagle12/MTA-SA---Eagle-Loader)** - Required for dynamic model and texture loading.
* **[Radar_Core](https://github.com/BlueEagle12/Radar-Core)** - Required for the custom radar system used by this map.

Make sure both resources are installed and started before starting `MTA-Liberty-City`.

Example start order:

```xml
<resource src="Radar_Core" startup="1" protected="0" />
<resource src="eagleLoader" startup="1" protected="0" />
<resource src="MTA-Liberty-City" startup="1" protected="0" />
```

---

## Bug Reports & Contributions

* Found a bug? Please open an issue or report it on [Discord](https://discord.gg/q8ZTfGqRXj)
* Have a fix? Submit a pull request and let me know so I can review it.

---

## Community & Support

Join the **Black Bear Studios Discord** for:

* Support with integration or scripting
* Easier bug reporting
* Feedback & collaboration

[Join the Black Bear Studios Discord](https://discord.gg/q8ZTfGqRXj)
