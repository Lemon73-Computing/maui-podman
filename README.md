# maui-podman -- a Docker container for reproducably setting up a MAUI development environment

This is intended to demonstrate issues with [maui-linux](https://github.com/jsuarezruiz/maui-linux) and not 
for active development as changes in the container would get lost on a `podman build`.

Note: You need to have [Podman](https://podman.io/docs/installation) installed and set up 
on your system to use this.

After git-cloning and cd into the repo, build the image:

```sh
sudo podman build -t maui-env .
```

This will build MAUI along with GtkSharp already. Then visit the container using:

```sh
sudo podman run -i --rm -t maui-env bash
```

Visual Studio Code is encouraged: Install VS Codes 'Dev Containers' extension, then right click the 
maui-env container and attach it to VS Code. To launch a sample app, start go to Open Folder in VS Code,
choose /mauienv/maui-linux, let Code install recommended extensions,  and enter these commands in VS Codes terminal window:

```sh
cd /mauienv/maui-linux/src/Controls/samples/Controls.Sample
dotnet run --framework net8.0-gtk
```

VS Code will then do some magic and start the gtk app on the container's host, without the need to explicitely install a .NET runtime there.

