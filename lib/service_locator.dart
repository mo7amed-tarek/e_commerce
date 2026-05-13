import 'package:get_it/get_it.dart';
import '../core/network/api_service.dart';
import '../data/remote/products_remote_data_source.dart';
import '../data/remote/cart_remote_data_source.dart';
import '../data/remote/wishlist_remote_data_source.dart';
import '../data/repositories/products_repository.dart';
import '../data/repositories/cart_repository.dart';
import '../data/repositories/wishlist_repository.dart';
import '../presentation/cubits/home_cubit.dart';
import '../presentation/cubits/products_cubit.dart';
import '../presentation/cubits/cart_cubit.dart';
import '../presentation/cubits/wishlist_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  // ─── API Service ───────────────────────────────────────────────
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // ─── Remote Data Sources ────────────────────────────────────────
  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSource(apiService: sl()),
  );
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSource(apiService: sl()),
  );
  sl.registerLazySingleton<WishlistRemoteDataSource>(
    () => WishlistRemoteDataSourceImpl(sl()),
  ); // ✅ مهم

  // ─── Repositories ──────────────────────────────────────────────
  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(remoteDataSource: sl()),
  );

  // ─── Cubits ────────────────────────────────────────────────────
  sl.registerFactory<HomeCubit>(() => HomeCubit(productsRepository: sl()));
  sl.registerFactory<ProductsCubit>(
    () => ProductsCubit(productsRepository: sl()),
  );
  sl.registerLazySingleton<CartCubit>(() => CartCubit(cartRepository: sl()));
  sl.registerLazySingleton<WishlistCubit>(
    () => WishlistCubit(wishlistRepository: sl()),
  );
}
