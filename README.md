# scripts2pkg

A Ruby gem to convert Python/Ruby scripts into Debian packages in Termux for Termux and Debian systems.

## Features

- Convert scripts to Debian packages with minimal configuration
- Support for both Termux and standard Debian systems
- Interactive and non-interactive modes
- Customizable package metadata (name, version, dependencies, architecture)
- Automatic directory structure generation

## Installation

Install the gem with:

```bash
gem install scripts2pkg
```

## Usage

### Interactive Mode

Simply run the command without arguments:

```bash
scripts2pkg package
```

The tool will prompt you for:
- Source filenames (comma-separated)
- Package name
- Package version
- Package dependencies (comma-separated)
- Package architecture
- Whether the package is for Termux

### Non-interactive Mode

Provide all options as command-line arguments:

```bash
scripts2pkg package \
  --source_files script1.py,script2.rb \
  --package-name my-package \
  --package-version 1.0.0 \
  --dependencies python3,ruby \
  --architecture all \
  --termux
```

### Options

| Option               | Description                                      | Required | Default |
|----------------------|--------------------------------------------------|----------|---------|
| --source_files       | Comma-separated list of source files            | No       | []      |
| --package-name       | Name of the package                              | No*      | -       |
| --package-version    | Version of the package                           | No       | -       |
| --dependencies      | Comma-separated list of dependencies            | No       | []      |
| --architecture      | Target architecture (e.g., all, arm64)          | No       | -       |
| --termux            | Whether the package is for Termux               | No       | false   |

*Required in non-interactive mode

## Output Structure

The tool creates a directory structure following Debian package conventions:

```
package_name_version/
├── DEBIAN/
│   └── control
└── usr/local/bin/ (or /data/data/com.termux/files/usr/bin/ for Termux)
    └── script_files
```

## Building the Package

After generation, build the package with:

```bash
dpkg-deb --build package_directory
```

## Example

1. Create a package for Termux:

```bash
scripts2pkg package \
  --source_files hello.py \
  --package-name hello-termux \
  --package-version 1.0 \
  --dependencies python \
  --architecture all \
  --termux
```

2. Build the package:

```bash
dpkg-deb --build hello-termux_1.0
```

## Requirements

- Ruby 2.5+
- dpkg-deb (for package building)
- Basic Debian packaging knowledge

## License

MIT License. See LICENSE file for details.

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Support

For issues or questions, please open an issue on [GitHub](https://github.com/funterminal/scripts2pkg.git).
