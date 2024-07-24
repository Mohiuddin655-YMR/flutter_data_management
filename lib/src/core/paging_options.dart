part of 'configs.dart';

class PagingOptions extends InAppPagingOptions {
  const PagingOptions({
    super.initialFetchSize,
    super.fetchFromLast = false,
    super.fetchingSize,
  });
}
