import 'docker.dart';
import 'exceptions.dart';
import 'volume.dart';

/// Holds a list of Docker containers.
class Volumes {
  /// Factory ctor
  factory Volumes() => _self;
  Volumes._internal();

  static final _self = Volumes._internal();

  /// returns a list of containers.
  List<Volume> volumes() {
    final volumeCache = <Volume>[];

    const args = [
      'ls',
      '--format',
      'table {{.Name}}|{{.Driver}}|{{.Mountpoint}}|{{.Labels}}|{{.Scope}}'
    ];

    final lines = dockerRun('volume', args)
        // remove the heading.
        .toList()
      ..removeAt(0);

    for (final line in lines) {
      final parts = line.split('|');
      final name = parts[0];
      final driver = parts[1];
      final mountpoint = parts[2];
      final labels = parts[3];
      final scope = parts[4];

      final container = Volume(
        name: name,
        driver: driver,
        mountpoint: mountpoint,
        labels: _splitLabels(labels),
        scope: scope,
      );
      volumeCache.add(container);
      //}
    }
    return volumeCache;
  }

  /// Finds and returns the volume with given name.
  /// Returns null if the volume doesn't exist.
  Volume? findByName(String name) {
    final list = volumes();

    for (final volume in list) {
      if (name == volume.name) {
        return volume;
      }
    }
    return null;
  }

  List<VolumeLabel> _splitLabels(String labelPairs) {
    final labels = <VolumeLabel>[];

    if (labelPairs.trim().isEmpty) {
      return labels;
    }
    final parts = labelPairs.split(',');

    for (final label in parts) {
      final pair = label.split('=');
      if (pair.length != 2) {
        throw InvalidVolumeLabelException(label);
      }
      labels.add(VolumeLabel(pair[0], pair[1]));
    }
    return labels;
  }
}

/// A volume label containing the key and value
class VolumeLabel {
  /// A volume label containing the key and value
  VolumeLabel(this.key, this.value);

  /// The key
  String key;

  /// The value
  String value;
}
