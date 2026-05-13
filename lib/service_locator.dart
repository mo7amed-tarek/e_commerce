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

import '../auth/data/repositories.dart';
import '../auth/presentation/cubits/auth_cubit.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<ApiService>(() => ApiService());

  sl.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSource(apiService: sl()),
  );
  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSource(apiService: sl()),
  );
  sl.registerLazySingleton<WishlistRemoteDataSource>(
    () => WishlistRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(apiService: sl()),
  );

  sl.registerLazySingleton<HomeCubit>(() => HomeCubit(productsRepository: sl()));
  sl.registerLazySingleton<ProductsCubit>(
    () => ProductsCubit(productsRepository: sl()),
  );
  sl.registerLazySingleton<CartCubit>(() => CartCubit(cartRepository: sl()));
  sl.registerLazySingleton<WishlistCubit>(
    () => WishlistCubit(wishlistRepository: sl()),
  );
  sl.registerFactory<AuthCubit>(() => AuthCubit(repository: sl()));
}
