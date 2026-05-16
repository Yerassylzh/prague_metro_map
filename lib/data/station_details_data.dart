import '../models/station_detail.dart';
import '../models/station.dart';
import 'metro_data.dart';

final Map<String, StationDetail> stationDetails = {
  for (final station in MetroData.allStations) station.id: _detailFor(station.id),
};

StationDetail _detailFor(String stationId) {
  final station = MetroData.getStation(stationId)!;
  final line = MetroData.getLine(station.lineId)!;
  final transferNames = station.transferTo
      .map(MetroData.getStation)
      .whereType<Station>()
      .map((s) => s.name['cs'] ?? s.name['en'] ?? s.id)
      .toList();
  final stationName = station.name['cs'] ?? station.name['en'] ?? station.id;
  final lineName = line.name['cs'] ?? line.name['en'] ?? line.id;
  final notableNote = _notableNote(station.id);

  return StationDetail(
    nearbyPlaces: _nearbyPlaces(station.id),
    nearbyTransport: NearbyTransport(
      other: [
        {
          'en': 'Integrated Prague public transport connections may include trams, buses, railway, or regional links depending on the station.',
          'ru': 'Пересадки в системе общественного транспорта Праги могут включать трамваи, автобусы, железную дорогу или региональные линии в зависимости от станции.',
          'cs': 'Navazujici doprava PID muze podle stanice zahrnovat tramvaje, autobusy, zeleznici nebo regionalni spoje.',
        },
      ],
    ),
    notes: [
      {
        'en': '$stationName is a Prague Metro station on $lineName.',
        'ru': '$stationName — станция пражского метро на линии ${line.number}.',
        'cs': '$stationName je stanice prazskeho metra na $lineName.',
      },
      if (transferNames.isNotEmpty)
        {
          'en': 'Transfer station: change here to ${transferNames.join(', ')}.',
          'ru': 'Пересадочная станция: здесь можно перейти на ${transferNames.join(', ')}.',
          'cs': 'Prestupni stanice: zde lze prestoupit na ${transferNames.join(', ')}.',
        },
      if (notableNote != null) notableNote,
    ],
    sources: const [
      'https://www.dpp.cz',
      'https://pid.cz/en/metro/',
      'https://en.wikipedia.org/wiki/List_of_Prague_Metro_stations',
    ],
    verifiedDate: '2026-05-15',
    confidence: const {
      'en': 'medium-high',
      'ru': 'средне-высокая',
      'cs': 'stredne vysoka',
    },
  );
}

List<LocalizedText> _nearbyPlaces(String stationId) {
  return switch (stationId) {
    'nemocnice_motol' => const [
        {
          'en': 'Motol University Hospital',
          'ru': 'Университетская больница Мотол',
          'cs': 'Fakultni nemocnice Motol',
        },
      ],
    'nadrazi_veleslavin' => const [
        {
          'en': 'Praha-Veleslavin railway station; airport bus connection area',
          'ru': 'Железнодорожная станция Прага-Велеславин; зона автобусной связи с аэропортом',
          'cs': 'Zeleznicni stanice Praha-Veleslavin; oblast navaznych autobusu na letiste',
        },
      ],
    'hradcanska' => const [
        {
          'en': 'Prague Castle access area',
          'ru': 'Район доступа к Пражскому Граду',
          'cs': 'Oblast pristupu k Prazskemu hradu',
        },
      ],
    'staromestska' => const [
        {
          'en': 'Old Town, Jewish Quarter, Charles Bridge area',
          'ru': 'Старый город, Еврейский квартал, район Карлова моста',
          'cs': 'Stare Mesto, Josefov, oblast Karlova mostu',
        },
      ],
    'mustek_a' || 'mustek_b' => const [
        {
          'en': 'Wenceslas Square and central Prague',
          'ru': 'Вацлавская площадь и центр Праги',
          'cs': 'Vaclavske namesti a centrum Prahy',
        },
      ],
    'muzeum_a' || 'muzeum_c' => const [
        {
          'en': 'National Museum; upper Wenceslas Square',
          'ru': 'Национальный музей; верхняя часть Вацлавской площади',
          'cs': 'Narodni muzeum; horni cast Vaclavskeho namesti',
        },
      ],
    'florenc_b' || 'florenc_c' => const [
        {
          'en': 'Florenc central bus station',
          'ru': 'Центральный автовокзал Флоренц',
          'cs': 'UAN Florenc',
        },
      ],
    'hlavni_nadrazi' => const [
        {
          'en': 'Prague main railway station',
          'ru': 'Главный железнодорожный вокзал Праги',
          'cs': 'Praha hlavni nadrazi',
        },
      ],
    'smichovske_nadrazi' => const [
        {
          'en': 'Praha-Smichov railway station',
          'ru': 'Железнодорожная станция Прага-Смихов',
          'cs': 'Zeleznicni stanice Praha-Smichov',
        },
      ],
    'vysehrad' => const [
        {
          'en': 'Vysehrad fortress area',
          'ru': 'Район крепости Вышеград',
          'cs': 'Oblast Vysehradu',
        },
      ],
    'chodov' => const [
        {
          'en': 'Westfield Chodov shopping centre',
          'ru': 'Торговый центр Westfield Chodov',
          'cs': 'Obchodni centrum Westfield Chodov',
        },
      ],
    'letnany' => const [
        {
          'en': 'Letnany exhibition and park-and-ride area',
          'ru': 'Выставочная зона Летняны и перехватывающая парковка',
          'cs': 'Vystavni areal Letnany a oblast P+R',
        },
      ],
    _ => const [],
  };
}

LocalizedText? _notableNote(String stationId) {
  return switch (stationId) {
    'mustek_a' || 'mustek_b' => const {
        'en': 'Můstek is the transfer complex between Line A and Line B.',
        'ru': 'Můstek — пересадочный узел между линиями A и B.',
        'cs': 'Mustek je prestupni uzel mezi linkami A a B.',
      },
    'muzeum_a' || 'muzeum_c' => const {
        'en': 'Muzeum is the transfer complex between Line A and Line C.',
        'ru': 'Muzeum — пересадочный узел между линиями A и C.',
        'cs': 'Muzeum je prestupni uzel mezi linkami A a C.',
      },
    'florenc_b' || 'florenc_c' => const {
        'en': 'Florenc is the transfer complex between Line B and Line C.',
        'ru': 'Florenc — пересадочный узел между линиями B и C.',
        'cs': 'Florenc je prestupni uzel mezi linkami B a C.',
      },
    _ => null,
  };
}
