<!--
SPDX-FileCopyrightText: 2022 Herbert Thielen <thielen@hs-worms.de>

SPDX-License-Identifier: EUPL-1.2 or GPL-3.0-or-later

For multi licensing syntax, see https://reuse.software/faq/#multi-licensing
-->

# Base of a Free Software Project using EUPL or GPL

This repository may be used as a starting point for [Free
Software](https://www.gnu.org/philosophy/free-sw.html) projects using
[EUPLv1.2](https://joinup.ec.europa.eu/collection/eupl/eupl-text-eupl-12) or
[GPLv3](https://www.gnu.org/licenses/quick-guide-gplv3).

Some background information of these licenses is available her:
[EUPL](https://ec.europa.eu/info/european-union-public-licence_en),
[GPL](https://www.gnu.org/licenses/#GPL).

## Contents of this page

[[_TOC_]]

## Usage

As usual, you may just clone this repository and build your project based on
the initial files, or you may just copy the files of this repository.

Of course you may just start a new project by yourself based on these licenses
(or other licenses); the benefit included in this repository is just the base
set of licenses 'ready to use', combined with headers compliant the
[reuse](https://reuse.software) tool (see below), and a software test running
in a GitLab CI/CD pipeline, see [.gitlab-ci.yml](.gitlab-ci.yml).

To verify that all files contain a suitable license hint, you may install
`reuse` as a pre-commit command, see
[.pre-commit-config.yaml](.pre-commit-config.yaml).

## License

If not mentioned otherwise in a file, you may use the GPLv3 or the
EUPLv1.2 or later versions of these licenses, see below.

Every file should contain a REUSE compliant license note in the
header.

See https://reuse.software to confirm REUSE compliance, e.g. run
`reuse lint`.

### GPLv3 or later

This project is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this project.  If not, see <http://www.gnu.org/licenses/>.

See [LICENSES/GPL-3.0-or-later.txt](./LICENSES/GPL-3.0-or-later.txt).

### EUPL-1.2

Alternatively to GPLv3, this project is also licensed under the
European Union Public License v. 1.2 or later.

See [LICENSES/EUPL-1.2.txt](./LICENSES/EUPL-1.2.txt).

### CC0

Minor files, e.g. [.gitignore](./.gitignore), may be licensed under
the creative commons zero license, see [LICENSES/CC0-1.0.txt](./LICENSES/CC0-1.0.txt).

