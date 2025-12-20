import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

/// https://stackoverflow.com/questions/69372529/how-to-implement-debouncer-for-events-with-onevent
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return events.debounce(duration).switchMap((mapper));
  };
}
