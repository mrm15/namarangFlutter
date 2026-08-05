enum WorkStatus {
  ready('ready'),
  notReady('not_ready');

  const WorkStatus(this.apiValue);

  final String apiValue;

  static WorkStatus? fromApi(String? value) {
    for (final status in values) {
      if (status.apiValue == value) return status;
    }
    return null;
  }
}
