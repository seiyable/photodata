class SimilarColor {
  String filename;
  String kind;
  String original_hex;
  String japanese_hex;
  color  original_rgb;
  color  japanese_rgb;
  String colorName;
  int percent; 

  SimilarColor(
  String _f, 
  String _k, 
  String _oh, 
  String _jh, 
  color  _or, 
  color  _jr, 
  String _c, 
  int _p) {
    filename     = _f;
    kind         = _k;
    original_hex = _oh;
    japanese_hex = _jh;
    original_rgb = _or;
    japanese_rgb = _jr;
    colorName    = _c;
    percent      = _p;
  }
}

