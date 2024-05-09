String handleFirebaseStorageError(e) {
  switch (e.code) {
    case 'object-not-found':
      return 'The requested object was not found.';
    case 'bucket-not-found':
      return 'The specified bucket does not exist.';
    case 'project-not-found':
      return 'The specified project does not exist.';
    case 'quota-exceeded':
      return 'The storage quota has been exceeded.';
    case 'unauthenticated':
      return 'User is not authenticated.';
    case 'unownerized':
      return 'User is not ownerized to perform this action.';
    case 'retry-limit-exceeded':
      return 'Retry limit exceeded for the operation.';
    case 'non-retryable-error':
      return 'An error occurred that cannot be retried.';
    case 'invalid-checksum':
      return 'Checksum of the uploaded file does not match the expected value.';
    case 'canceled':
      return 'The operation was canceled.';
    case 'invalid-event-name':
      return 'Invalid event name specified.';
    case 'invalid-argument':
      return 'Invalid argument passed to the operation.';
    case 'not-found':
      return 'Resource not found.';
    case 'already-exists':
      return 'Resource already exists.';
    case 'permission-denied':
      return 'Permission denied to access the requested resource.';
    case 'resource-exhausted':
      return 'Resource has been exhausted, such as bandwidth or storage limit.';
    case 'failed-precondition':
      return 'Operation failed due to the current state of the resource.';
    case 'aborted':
      return 'The operation was aborted.';
    case 'out-of-range':
      return 'Operation is out of valid range.';
    case 'internal':
      return 'Internal server error occurred.';
    case 'unavailable':
      return 'The service is currently unavailable.';
    case 'data-loss':
      return 'Data loss occurred during the operation.';
    default:
      return e.message.toString();
  }
}

String timeAgo(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inSeconds < 0) {
    return "${d.day}-${d.month}-${d.year}";
  }
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  }
  return "just now";
}
String mergeStrings(String str1, String str2) {
  if (str1.compareTo(str2) >= 0) {
    return str1 + str2;
  } else {
    return str2 + str1;
  }
}