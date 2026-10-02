# Agent environment

## Local project guidance

The checkout contains two local, intentionally untracked guidance artifacts:

- `AGENTS.md` with repository-wide engineering rules;
- `.agent-skills/plasma6-plasmoid/` with a focused Plasma 6 development skill.

They are excluded by `.gitignore`, as are `.agents/`, `.codex/`, MCP-local files, caches, and environment files that can contain credentials. The skill was created with the standard skill initializer and validated during Milestone 0.

## Tools and MCP inventory

The coding environment provides direct workspace filesystem access, shell execution, web access, and Git. Those built-in capabilities cover the current development tasks.

MCP discovery exposed only the `codex_apps` server with optional document-template, Pets, Plugin Management, and Sites resources. None is relevant to a local Plasma/QML launcher, so no external app connection was added. There is currently no separate filesystem, Git, GitHub, Qt, or KDE MCP server connected.

The repository has a GitHub SSH remote (`git@github.com:Apophuy/apophuy-menu.git`), but Milestone 0 required no GitHub account mutation and no GitHub connector.

## Purpose of the active capabilities

| Capability | Use in this project |
| --- | --- |
| Workspace filesystem and shell | inspect installed Plasma, edit the project, run lint/tests, package the plasmoid |
| Git | small local commits and change review |
| Web | official KDE/Qt documentation and upstream source cross-checks |
| Debian source packages | exact source corresponding to the installed Plasma/libplasma versions |

No MCP or plugin should be connected merely for availability. Add one only when a concrete task cannot be completed safely with the capabilities above, then document its permissions and purpose here.

## External source policy

Use sources in this order:

1. installed files and matching Debian source packages;
2. current upstream KDE source;
3. [KDE Plasma widget documentation](https://develop.kde.org/docs/plasma/widget/);
4. [KDE Plasma QML API](https://api.kde.org/qml-org-kde-plasma-plasmoid-plasmoiditem.html);
5. [Qt 6 QML documentation](https://doc.qt.io/qt-6/qtqml-index.html);
6. third-party material only when the preceding sources do not answer the question.

Simple Kickoff is explicitly a UX reference, not a technical authority.
