import 'package:flutter/material.dart';
import '../models/station.dart';
import '../models/line.dart';

class MetroData {
  static final List<MetroLine> lines = [
    MetroLine(
      id: 'line_a',
      number: 'A',
      name: const {
        'en': 'Line A',
        'ru': 'Линия A',
        'cs': 'Linka A',
      },
      color: const Color(0xFF009A5B),
      stationIds: const [
        'nemocnice_motol',
        'petriny',
        'nadrazi_veleslavin',
        'borislavka',
        'dejvicka',
        'hradcanska',
        'malostranska',
        'staromestska',
        'mustek_a',
        'muzeum_a',
        'namesti_miru',
        'jiriho_z_podebrad',
        'flora',
        'zelivskeho',
        'strasnicka',
        'skalka',
        'depo_hostivar',
      ],
      path: const [
        PathNode.station('nemocnice_motol'),
        PathNode.station('petriny'),
        PathNode.station('nadrazi_veleslavin'),
        PathNode.station('borislavka'),
        PathNode.station('dejvicka'),
        PathNode.point(0.36, 0.20),
        PathNode.station('hradcanska'),
        PathNode.station('malostranska'),
        PathNode.station('staromestska'),
        PathNode.station('mustek_a'),
        PathNode.station('muzeum_a'),
        PathNode.station('namesti_miru'),
        PathNode.station('jiriho_z_podebrad'),
        PathNode.station('flora'),
        PathNode.station('zelivskeho'),
        PathNode.station('strasnicka'),
        PathNode.station('skalka'),
        PathNode.station('depo_hostivar'),
      ],
    ),
    MetroLine(
      id: 'line_b',
      number: 'B',
      name: const {
        'en': 'Line B',
        'ru': 'Линия B',
        'cs': 'Linka B',
      },
      color: const Color(0xFFF7D117),
      stationIds: const [
        'zlicin',
        'stodulky',
        'luka',
        'luziny',
        'hurka',
        'nove_butovice',
        'jinonice',
        'radlicka',
        'smichovske_nadrazi',
        'andel',
        'karlovo_namesti',
        'narodni_trida',
        'mustek_b',
        'namesti_republiky',
        'florenc_b',
        'krizikova',
        'invalidovna',
        'palmovka',
        'ceskomoravska',
        'vysocanska',
        'kolbenova',
        'hloubetin',
        'rajska_zahrada',
        'cerny_most',
      ],
      path: const [
        PathNode.station('zlicin'),
        PathNode.station('stodulky'),
        PathNode.station('luka'),
        PathNode.station('luziny'),
        PathNode.station('hurka'),
        PathNode.station('nove_butovice'),
        PathNode.station('jinonice'),
        PathNode.station('radlicka'),
        PathNode.station('smichovske_nadrazi'),
        PathNode.station('andel'),
        PathNode.station('karlovo_namesti'),
        PathNode.station('narodni_trida'),
        PathNode.station('mustek_b'),
        PathNode.station('namesti_republiky'),
        PathNode.station('florenc_b'),
        PathNode.station('krizikova'),
        PathNode.station('invalidovna'),
        PathNode.station('palmovka'),
        PathNode.station('ceskomoravska'),
        PathNode.station('vysocanska'),
        PathNode.station('kolbenova'),
        PathNode.station('hloubetin'),
        PathNode.station('rajska_zahrada'),
        PathNode.station('cerny_most'),
      ],
    ),
    MetroLine(
      id: 'line_c',
      number: 'C',
      name: const {
        'en': 'Line C',
        'ru': 'Линия C',
        'cs': 'Linka C',
      },
      color: const Color(0xFFE94B35),
      stationIds: const [
        'letnany',
        'prosek',
        'strizkov',
        'ladvi',
        'kobylisy',
        'nadrazi_holesovice',
        'vltavska',
        'florenc_c',
        'hlavni_nadrazi',
        'muzeum_c',
        'ip_pavlova',
        'vysehrad',
        'prazskeho_povstani',
        'pankrac',
        'budejovicka',
        'kacerov',
        'roztyly',
        'chodov',
        'opatov',
        'haje',
      ],
      path: const [
        PathNode.station('letnany'),
        PathNode.station('prosek'),
        PathNode.station('strizkov'),
        PathNode.station('ladvi'),
        PathNode.station('kobylisy'),
        PathNode.station('nadrazi_holesovice'),
        PathNode.station('vltavska'),
        PathNode.station('florenc_c'),
        PathNode.station('hlavni_nadrazi'),
        PathNode.station('muzeum_c'),
        PathNode.station('ip_pavlova'),
        PathNode.station('vysehrad'),
        PathNode.station('prazskeho_povstani'),
        PathNode.station('pankrac'),
        PathNode.station('budejovicka'),
        PathNode.station('kacerov'),
        PathNode.station('roztyly'),
        PathNode.station('chodov'),
        PathNode.station('opatov'),
        PathNode.station('haje'),
      ],
    ),
  ];

  static final Map<String, Station> stations = {
    'nemocnice_motol': _s('nemocnice_motol', 'Nemocnice Motol', 'line_a', 0.03, 0.18),
    'petriny': _s('petriny', 'Petřiny', 'line_a', 0.09, 0.18),
    'nadrazi_veleslavin': _s('nadrazi_veleslavin', 'Nádraží Veleslavín', 'line_a', 0.16, 0.18),
    'borislavka': _s('borislavka', 'Bořislavka', 'line_a', 0.23, 0.18),
    'dejvicka': _s('dejvicka', 'Dejvická', 'line_a', 0.30, 0.18),
    'hradcanska': _s('hradcanska', 'Hradčanská', 'line_a', 0.36, 0.31),
    'malostranska': _s('malostranska', 'Malostranská', 'line_a', 0.43, 0.43),
    'staromestska': _s('staromestska', 'Staroměstská', 'line_a', 0.52, 0.43),
    'mustek_a': _s('mustek_a', 'Můstek', 'line_a', 0.58, 0.51, ['mustek_b']),
    'muzeum_a': _s('muzeum_a', 'Muzeum', 'line_a', 0.67, 0.61, ['muzeum_c']),
    'namesti_miru': _s('namesti_miru', 'Náměstí Míru', 'line_a', 0.76, 0.69),
    'jiriho_z_podebrad': _s('jiriho_z_podebrad', 'Jiřího z Poděbrad', 'line_a', 0.84, 0.66),
    'flora': _s('flora', 'Flora', 'line_a', 0.93, 0.66),
    'zelivskeho': _s('zelivskeho', 'Želivského', 'line_a', 1.02, 0.66),
    'strasnicka': _s('strasnicka', 'Strašnická', 'line_a', 1.10, 0.73),
    'skalka': _s('skalka', 'Skalka', 'line_a', 1.19, 0.78),
    'depo_hostivar': _s('depo_hostivar', 'Depo Hostivař', 'line_a', 1.31, 0.78),

    'zlicin': _s('zlicin', 'Zličín', 'line_b', 0.02, 0.76),
    'stodulky': _s('stodulky', 'Stodůlky', 'line_b', 0.08, 0.82),
    'luka': _s('luka', 'Luka', 'line_b', 0.14, 0.86),
    'luziny': _s('luziny', 'Lužiny', 'line_b', 0.20, 0.86),
    'hurka': _s('hurka', 'Hůrka', 'line_b', 0.26, 0.86),
    'nove_butovice': _s('nove_butovice', 'Nové Butovice', 'line_b', 0.32, 0.86),
    'jinonice': _s('jinonice', 'Jinonice', 'line_b', 0.38, 0.86),
    'radlicka': _s('radlicka', 'Radlická', 'line_b', 0.43, 0.83),
    'smichovske_nadrazi': _s('smichovske_nadrazi', 'Smíchovské nádraží', 'line_b', 0.47, 0.76),
    'andel': _s('andel', 'Anděl', 'line_b', 0.49, 0.68),
    'karlovo_namesti': _s('karlovo_namesti', 'Karlovo náměstí', 'line_b', 0.58, 0.68),
    'narodni_trida': _s('narodni_trida', 'Národní třída', 'line_b', 0.59, 0.60),
    'mustek_b': _s('mustek_b', 'Můstek', 'line_b', 0.58, 0.51, ['mustek_a']),
    'namesti_republiky': _s('namesti_republiky', 'Náměstí Republiky', 'line_b', 0.70, 0.51),
    'florenc_b': _s('florenc_b', 'Florenc', 'line_b', 0.82, 0.51, ['florenc_c']),
    'krizikova': _s('krizikova', 'Křižíkova', 'line_b', 0.91, 0.51),
    'invalidovna': _s('invalidovna', 'Invalidovna', 'line_b', 0.97, 0.43),
    'palmovka': _s('palmovka', 'Palmovka', 'line_b', 1.04, 0.35),
    'ceskomoravska': _s('ceskomoravska', 'Českomoravská', 'line_b', 1.12, 0.27),
    'vysocanska': _s('vysocanska', 'Vysočanská', 'line_b', 1.15, 0.25),
    'kolbenova': _s('kolbenova', 'Kolbenova', 'line_b', 1.23, 0.25),
    'hloubetin': _s('hloubetin', 'Hloubětín', 'line_b', 1.31, 0.25),
    'rajska_zahrada': _s('rajska_zahrada', 'Rajská zahrada', 'line_b', 1.39, 0.25),
    'cerny_most': _s('cerny_most', 'Černý Most', 'line_b', 1.47, 0.25),

    'letnany': _s('letnany', 'Letňany', 'line_c', 1.24, 0.13),
    'prosek': _s('prosek', 'Prosek', 'line_c', 1.11, 0.13),
    'strizkov': _s('strizkov', 'Střížkov', 'line_c', 1.03, 0.08),
    'ladvi': _s('ladvi', 'Ládví', 'line_c', 0.94, 0.03),
    'kobylisy': _s('kobylisy', 'Kobylisy', 'line_c', 0.84, 0.03),
    'nadrazi_holesovice': _s('nadrazi_holesovice', 'Nádraží Holešovice', 'line_c', 0.84, 0.23),
    'vltavska': _s('vltavska', 'Vltavská', 'line_c', 0.84, 0.36),
    'florenc_c': _s('florenc_c', 'Florenc', 'line_c', 0.82, 0.51, ['florenc_b']),
    'hlavni_nadrazi': _s('hlavni_nadrazi', 'Hlavní nádraží', 'line_c', 0.75, 0.58),
    'muzeum_c': _s('muzeum_c', 'Muzeum', 'line_c', 0.67, 0.61, ['muzeum_a']),
    'ip_pavlova': _s('ip_pavlova', 'I. P. Pavlova', 'line_c', 0.64, 0.73),
    'vysehrad': _s('vysehrad', 'Vyšehrad', 'line_c', 0.64, 0.84),
    'prazskeho_povstani': _s('prazskeho_povstani', 'Pražského povstání', 'line_c', 0.68, 0.90),
    'pankrac': _s('pankrac', 'Pankrác', 'line_c', 0.73, 0.95),
    'budejovicka': _s('budejovicka', 'Budějovická', 'line_c', 0.79, 1.00),
    'kacerov': _s('kacerov', 'Kačerov', 'line_c', 0.84, 0.99),
    'roztyly': _s('roztyly', 'Roztyly', 'line_c', 0.94, 0.99),
    'chodov': _s('chodov', 'Chodov', 'line_c', 1.04, 0.99),
    'opatov': _s('opatov', 'Opatov', 'line_c', 1.14, 0.99),
    'haje': _s('haje', 'Háje', 'line_c', 1.24, 0.99),
  };

  static Station _s(
    String id,
    String name,
    String lineId,
    double x,
    double y, [
    List<String> transferTo = const [],
  ]) {
    return Station(
      id: id,
      name: {
        'en': name,
        'ru': name,
        'cs': name,
      },
      lineId: lineId,
      x: x,
      y: y,
      transferTo: transferTo,
    );
  }

  static Station? getStation(String id) => stations[id];

  static MetroLine? getLine(String id) {
    for (final line in lines) {
      if (line.id == id) return line;
    }
    return null;
  }

  static List<Station> getStationsOnLine(String lineId) {
    final line = getLine(lineId);
    if (line == null) return [];
    return line.stationIds
        .map((id) => stations[id])
        .whereType<Station>()
        .toList();
  }

  static List<Station> get allStations => stations.values.toList();

  static List<Station> searchStations(String query, String languageCode) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return stations.values.where((station) {
      final name = station.getLocalizedName(languageCode).toLowerCase();
      return name.contains(lowerQuery);
    }).toList();
  }
}
