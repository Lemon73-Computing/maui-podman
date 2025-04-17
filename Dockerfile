FROM mcr.microsoft.com/dotnet/sdk:8.0

WORKDIR /mauienv

# set environment variable/path
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools

# install GtkSharp
RUN git clone https://github.com/GtkSharp/GtkSharp.git
WORKDIR /mauienv/GtkSharp
RUN sed -i 's/"8.0.100", "8.0.200"}/"8.0.100", "8.0.200", "8.0.300", "8.0.400"}/g' build.cake  # add missing version bands
RUN dotnet tool restore
  # ^ this allows debugging using the vscode devcontainer extension 
RUN dotnet cake --verbosity=diagnostic --BuildTarget=InstallWorkload 
RUN apt update
RUN apt install -y libgtk-3-dev libgtksourceview-4-0 
RUN dotnet new install GtkSharp.Template.CSharp

# install MAUI
WORKDIR /mauienv
# as of commit c005e3a -> should build on linux
RUN git clone https://github.com/jsuarezruiz/maui-linux
WORKDIR /mauienv/maui-linux
# from https://github.com/lytico/maui/blob/6ef7f0c066808ea0d4142812ef4d956245e6a711/.github/workflows/build-gtk.yml#L34-L36
RUN sed -i 's/_IncludeAndroid>true/_IncludeAndroid>/g' Directory.Build.Override.props
RUN dotnet build Microsoft.Maui.BuildTasks.slnf
RUN dotnet build Microsoft.Maui.Gtk.slnf

# running the sample app won't work as the container doesn't have a display attached -- use VS Code to do the trick!
# WORKDIR /mauienv/maui-linux/src/Controls/samples/Controls.Sample
# dotnet run --framework net8.0-gtk
