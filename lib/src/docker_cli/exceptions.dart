/// Base exception for all exceptions thrown by Docker2.
class DockerCliException implements Exception {}

/// Thrown if the given container does not exist.
class ContainerNotFoundException extends DockerCliException {}

/// The docker container is not running.
class ContainerNotRunning extends DockerCliException {}

/// The docker container is already running.
class ContainerAlreadyRunning extends DockerCliException {}

/// Thrown if the given container already exists.
class ContainerExistsException extends DockerCliException {
  /// Thrown if the given container already exists.
  ContainerExistsException(this.containerName);

  /// The container  that already exits.
  String containerName;
}

/// Thrown if the given [imageName] matched more than one
/// image.
class AmbiguousImageNameException extends DockerCliException {
  /// Thrown if the given [imageName] matched more than one
  /// image.
  AmbiguousImageNameException(this.imageName);

  /// The imageName  that was ambigous.
  String imageName;
}

/// Thrown if the given [label] matched more than one
/// image.
class InvalidVolumeLabelException extends DockerCliException {
  /// Thrown if a  volume label does not match the expect key=value format.
  InvalidVolumeLabelException(this.label);

  /// The imageName  that was ambigous.
  String label;
}

/// Thrown if the volume create failed.
class VolumeCreateException extends DockerCliException {
  /// Thrown if the volume create failed.
  VolumeCreateException(this.message);

  /// error message.
  String message;

  @override
  String toString() => message;
}

/// Thrown if you try to access a volume by a non-existant name
class UnknownVolumeException extends DockerCliException {
  /// Thrown if you try to access a volume by a non-existant name
  UnknownVolumeException(this.message);

  /// error message.
  String message;

  @override
  String toString() => message;
}

/// Throw if a docker command failed when we tried to execute it.
class DockerCommandFailed extends DockerCliException {
  /// Throw if a docker command failed when we tried to execute it.
  DockerCommandFailed(this.command, this.args, this.exitCode, this.error);

  /// the docker command that was being run.
  String command;

  /// the args we passed to the docker command.
  String args;

  /// the exit code returned from docker.
  int exitCode;

  /// The error message returned by docker.
  String error;

  @override
  String toString() => '''
Error running docker command: $command $args
Exit code: $exitCode
Error: 
$error
''';
}

/// Throw if the given image can't be found on the local system.
class ImageNotFoundException extends DockerCliException {
  /// Throw if the given image can't be found on the local system.
  ImageNotFoundException(this.fullName);

  /// the fullname of the image we were looking for.
  String fullName;
}
