import 'package:express_atypical/entities/categoria.dart';
import 'package:test/test.dart';

void main() {
  Categoria categoria = Categoria.empty();
  test('Validador de categoria deve barrar nome vazio', () {
    expect(categoria.validaCampos(), "Nome da categoria é obrigatório!");
  });
}