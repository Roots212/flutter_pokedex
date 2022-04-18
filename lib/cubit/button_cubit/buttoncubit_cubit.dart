import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'buttoncubit_state.dart';

class ButtonCubit extends Cubit<ButtoncubitState> {
  ButtonCubit() : super(ButtoncubitInitial());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  checkMarked(int id) async {
    final SharedPreferences prefs = await _prefs;
    List<String> favouritePokemonList = [];

    favouritePokemonList = prefs.getStringList('favourites') ?? [];
    if (favouritePokemonList.contains(id.toString())) {
      emit(ButtoncubitSaved());
    } else {
      emit(ButtoncubitNotSaved());
    }
  }
}
