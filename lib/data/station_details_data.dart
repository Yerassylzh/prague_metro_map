import '../models/station_detail.dart';
import '../models/station.dart';
import 'metro_data.dart';

final Map<String, StationDetail> stationDetails = {
  for (final station in MetroData.allStations) station.id: _detailFor(station.id),
};

StationDetail _detailFor(String stationId) {
  final curated = _curatedStationDetails[stationId];
  if (curated != null) return curated;

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

const Map<String, StationDetail> _curatedStationDetails = {
  'nemocnice_motol': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Motol University Hospital',
          'ru': 'Больница Мотол',
          'cs': 'Fakultní nemocnice Motol',
        },
        details: {
          'en': 'Main exit toward the hospital complex and bus terminal.',
          'ru': 'Главный выход к больничному комплексу и автобусному терминалу.',
          'cs': 'Hlavní výstup směrem k nemocničnímu areálu a autobusovému terminálu.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Motol University Hospital',
        'ru': 'Университетская больница Мотол',
        'cs': 'Fakultní nemocnice Motol',
      },
      {
        'en': 'Motol transport terminal',
        'ru': 'Транспортный терминал Мотол',
        'cs': 'Dopravní terminál Motol',
      },
    ],
    nearbyTransport: NearbyTransport(
      other: [
        {
          'en': 'Major city bus terminal',
          'ru': 'Крупный автобусный терминал',
          'cs': 'Významný autobusový terminál',
        },
      ],
    ),
    coordinates: '50.0756, 14.3407',
    notes: [
      {
        'en': 'Western terminus of Metro Line A.',
        'ru': 'Западная конечная станция линии A.',
        'cs': 'Západní konečná stanice linky A.',
      },
      {
        'en': 'Station primarily serves the hospital complex.',
        'ru': 'Станция в основном обслуживает больничный комплекс.',
        'cs': 'Stanice primárně obsluhuje nemocniční areál.',
      },
    ],
    sources: [
      'https://www.dpp.cz/',
      'https://cs.wikipedia.org/wiki/Nemocnice_Motol_(stanice_metra_v_Praze)',
      'https://www.openstreetmap.org/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'medium',
      'ru': 'medium',
      'cs': 'medium',
    },
  ),
  'petriny': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Na Petřinách street',
          'ru': 'Улица Na Petřinách',
          'cs': 'Na Petřinách',
        },
        details: {
          'en': 'Exit toward residential area and tram stops.',
          'ru': 'Выход к жилому району и трамвайным остановкам.',
          'cs': 'Výstup směrem k obytné oblasti a tramvajovým zastávkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Petřiny residential district',
        'ru': 'Жилой район Петршины',
        'cs': 'Sídliště Petřiny',
      },
      {
        'en': 'Břevnov area',
        'ru': 'Район Бржевнов',
        'cs': 'Břevnov',
      },
    ],
    coordinates: '50.0867, 14.3460',
    notes: [
      {
        'en': 'Deep-level station opened as part of the Line A western extension.',
        'ru': 'Глубокая станция, открытая в рамках западного продления линии A.',
        'cs': 'Hlubinná stanice otevřená v rámci západního prodloužení linky A.',
      },
    ],
    sources: [
      'https://www.dpp.cz/',
      'https://cs.wikipedia.org/wiki/Pet%C5%99iny_(stanice_metra_v_Praze)',
      'https://www.openstreetmap.org/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'medium',
      'ru': 'medium',
      'cs': 'medium',
    },
  ),
  'nadrazi_veleslavin': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Veleslavín railway station',
          'ru': 'Железнодорожная станция Велеславин',
          'cs': 'Nádraží Veleslavín',
        },
        details: {
          'en': 'Exit connected to railway station, buses, and tram interchange.',
          'ru': 'Выход с пересадкой на железную дорогу, автобусы и трамваи.',
          'cs': 'Výstup s přestupem na železnici, autobusy a tramvaje.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Veleslavín railway station',
        'ru': 'Станция Велеславин',
        'cs': 'Nádraží Veleslavín',
      },
      {
        'en': 'Transfer terminal to Václav Havel Airport area',
        'ru': 'Пересадочный терминал в сторону аэропорта Вацлава Гавела',
        'cs': 'Přestupní terminál směrem na Letiště Václava Havla',
      },
    ],
    nearbyTransport: NearbyTransport(
      other: [
        {
          'en': 'Railway connection',
          'ru': 'Железнодорожное сообщение',
          'cs': 'Železniční spojení',
        },
      ],
    ),
    coordinates: '50.0955, 14.3472',
    notes: [
      {
        'en': 'Important transfer station for airport bus services.',
        'ru': 'Важная пересадочная станция для автобусных маршрутов в аэропорт.',
        'cs': 'Významná přestupní stanice pro autobusové linky na letiště.',
      },
    ],
    sources: [
      'https://www.dpp.cz/',
      'https://cs.wikipedia.org/wiki/N%C3%A1dra%C5%BE%C3%AD_Veleslav%C3%ADn_(stanice_metra_v_Praze)',
      'https://www.openstreetmap.org/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'medium',
      'ru': 'medium',
      'cs': 'medium',
    },
  ),
  'borislavka': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Horoměřická street',
          'ru': 'Улица Горомержицка',
          'cs': 'Horoměřická',
        },
        details: {
          'en': 'Exit toward tram stops and suburban bus terminal.',
          'ru': 'Выход к трамвайным остановкам и пригородному автобусному терминалу.',
          'cs': 'Výstup směrem k tramvajovým zastávkám a příměstskému autobusovému terminálu.',
        },
      ),
      StationExit(
        location: {
          'en': 'Arabská street',
          'ru': 'Улица Арабска',
          'cs': 'Arabská',
        },
        details: {
          'en': 'Exit toward Červený Vrch residential area.',
          'ru': 'Выход к жилому району Червены Врх.',
          'cs': 'Výstup směrem k sídlišti Červený Vrch.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Bořislavka Centre',
        'ru': 'Торговый центр Bořislavka',
        'cs': 'Bořislavka Centrum',
      },
      {
        'en': 'Červený Vrch residential district',
        'ru': 'Жилой район Червены Врх',
        'cs': 'Sídliště Červený Vrch',
      },
    ],
    nearbyTransport: NearbyTransport(
      other: [
        {
          'en': 'Suburban bus terminal',
          'ru': 'Пригородный автобусный терминал',
          'cs': 'Příměstský autobusový terminál',
        },
      ],
    ),
    coordinates: '50.0985, 14.3641',
    notes: [
      {
        'en': 'Opened in 2015 as part of the western extension of Line A.',
        'ru': 'Открыта в 2015 году в рамках западного продления линии A.',
        'cs': 'Otevřena v roce 2015 v rámci západního prodloužení linky A.',
      },
      {
        'en': 'Originally planned under the name Červený Vrch.',
        'ru': 'Изначально планировалась под названием Červený Vrch.',
        'cs': 'Původně plánována pod názvem Červený Vrch.',
      },
    ],
    sources: [
      'https://www.dpp.cz/',
      'https://pid.cz/en/metro/',
      'https://en.wikipedia.org/wiki/Bo%C5%99islavka_%28Prague_Metro%29',
      'https://mapy.com/en/?id=15302862&source=pubt',
      'https://borislavka-centrum.cz/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'dejvicka': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Victory Square',
          'ru': 'Площадь Победы',
          'cs': 'Vítězné náměstí',
        },
        details: {
          'en': 'Eastern exit toward the main square and university area.',
          'ru': 'Восточный выход к главной площади и университетскому району.',
          'cs': 'Východní výstup směrem k hlavnímu náměstí a univerzitní oblasti.',
        },
      ),
      StationExit(
        location: {
          'en': 'Evropská avenue',
          'ru': 'Проспект Evropská',
          'cs': 'Evropská třída',
        },
        details: {
          'en': 'Western exit toward tram and bus interchange.',
          'ru': 'Западный выход к трамвайно-автобусному узлу.',
          'cs': 'Západní výstup směrem k tramvajové a autobusové dopravě.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Czech Technical University',
        'ru': 'Чешский технический университет',
        'cs': 'České vysoké učení technické',
      },
      {
        'en': 'Victory Square',
        'ru': 'Площадь Победы',
        'cs': 'Vítězné náměstí',
      },
      {
        'en': 'Dejvice district',
        'ru': 'Район Дейвице',
        'cs': 'Dejvice',
      },
    ],
    nearbyTransport: NearbyTransport(
      other: [
        {
          'en': 'Major tram and bus interchange',
          'ru': 'Крупный трамвайно-автобусный пересадочный узел',
          'cs': 'Významný tramvajový a autobusový přestupní uzel',
        },
      ],
    ),
    coordinates: '50.1009, 14.3936',
    notes: [
      {
        'en': 'Formerly named Leninova until 1990.',
        'ru': 'До 1990 года называлась Leninova.',
        'cs': 'Do roku 1990 nesla název Leninova.',
      },
      {
        'en': 'Western terminus of Line A until 2015.',
        'ru': 'Была западной конечной линии A до 2015 года.',
        'cs': 'Do roku 2015 byla západní konečnou linky A.',
      },
    ],
    sources: [
      'https://www.dpp.cz/',
      'https://pid.cz/en/dejvicka-3-2/',
      'https://en.wikipedia.org/wiki/Dejvick%C3%A1_%28Prague_Metro%29',
      'https://metro.angrenost.cz/a/de.php',
      'https://mapy.com/en/?id=15305616&source=pubt',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'hradcanska': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Milady Horákové street',
          'ru': 'Улица Милады Гораковой',
          'cs': 'Milady Horákové',
        },
        details: {
          'en': 'Main exits toward tram stops and Letná direction.',
          'ru': 'Главные выходы к трамвайным остановкам и району Летна.',
          'cs': 'Hlavní výstupy směrem k tramvajovým zastávkám a Letné.',
        },
      ),
      StationExit(
        location: {
          'en': 'Dejvická street',
          'ru': 'Улица Дейвицка',
          'cs': 'Dejvická',
        },
        details: {
          'en': 'Secondary exit toward Prague Castle walking route.',
          'ru': 'Дополнительный выход к пешеходному маршруту к Пражскому Граду.',
          'cs': 'Vedlejší výstup směrem k pěší trase na Pražský hrad.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Prague Castle',
        'ru': 'Пражский Град',
        'cs': 'Pražský hrad',
      },
      {
        'en': 'Letná district',
        'ru': 'Район Летна',
        'cs': 'Letná',
      },
      {
        'en': 'Hradčany district',
        'ru': 'Район Градчаны',
        'cs': 'Hradčany',
      },
    ],
    coordinates: '50.0972, 14.4047',
    notes: [
      {
        'en': 'Station opened in 1978 as part of the first Line A section.',
        'ru': 'Станция открыта в 1978 году как часть первого участка линии A.',
        'cs': 'Stanice byla otevřena v roce 1978 jako součást prvního úseku linky A.',
      },
      {
        'en': 'Prague Castle is reachable on foot in about 10 minutes.',
        'ru': 'До Пражского Града можно дойти пешком примерно за 10 минут.',
        'cs': 'Na Pražský hrad lze dojít pěšky přibližně za 10 minut.',
      },
    ],
    sources: [
      'https://www.dpp.cz/',
      'https://pid.cz/en/metro/',
      'https://en.wikipedia.org/wiki/Hrad%C4%8Dansk%C3%A1_%28Prague_Metro%29',
      'https://metro.angrenost.cz/a/hr.php',
      'https://www.dpp.cz/en/timetables/traffic-scheme',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'malostranska': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Klárov',
          'ru': 'Кларов',
          'cs': 'Klárov',
        },
        details: {
          'en': 'Main exit toward tram interchange, Prague Castle walking route, and Malá Strana.',
          'ru': 'Главный выход к трамвайному узлу, маршруту к Пражскому Граду и району Мала-Страна.',
          'cs': 'Hlavní výstup směrem k tramvajovému uzlu, trase na Pražský hrad a Malé Straně.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Wallenstein Palace',
        'ru': 'Валдштейнский дворец',
        'cs': 'Valdštejnský palác',
      },
      {
        'en': 'Prague Castle',
        'ru': 'Пражский Град',
        'cs': 'Pražský hrad',
      },
      {
        'en': 'Malá Strana',
        'ru': 'Мала-Страна',
        'cs': 'Malá Strana',
      },
    ],
    coordinates: '50.0910, 14.4095',
    notes: [
      {
        'en': 'Opened in 1978 as part of the first section of Line A.',
        'ru': 'Открыта в 1978 году как часть первого участка линии A.',
        'cs': 'Otevřena v roce 1978 jako součást prvního úseku linky A.',
      },
      {
        'en': 'Only one exit exists due to proximity to the Vltava River.',
        'ru': 'Существует только один выход из-за близости реки Влтавы.',
        'cs': 'Existuje pouze jeden výstup kvůli blízkosti řeky Vltavy.',
      },
      {
        'en': 'Interior design reflects the historic character of Malá Strana.',
        'ru': 'Дизайн станции отражает исторический характер Малой Страны.',
        'cs': 'Design stanice odráží historický charakter Malé Strany.',
      },
    ],
    sources: [
      'https://www.dpp.cz/en',
      'https://pid.cz/en/metro/',
      'https://en.wikipedia.org/wiki/Malostransk%C3%A1_%28Prague_Metro%29',
      'https://mapy.com/en/?id=15709733&source=pubt',
      'https://prague.eu/en/welcome-to-prague',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'staromestska': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Kaprova street',
          'ru': 'Улица Капрова',
          'cs': 'Kaprova',
        },
        details: {
          'en': 'Main exit toward Old Town Square, Rudolfinum, and Jewish Quarter.',
          'ru': 'Главный выход к Староместской площади, Рудольфинуму и Еврейскому кварталу.',
          'cs': 'Hlavní výstup směrem ke Staroměstskému náměstí, Rudolfinu a Židovské čtvrti.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Old Town Square',
        'ru': 'Староместская площадь',
        'cs': 'Staroměstské náměstí',
      },
      {
        'en': 'Rudolfinum',
        'ru': 'Рудольфинум',
        'cs': 'Rudolfinum',
      },
      {
        'en': 'Old Jewish Cemetery',
        'ru': 'Старое еврейское кладбище',
        'cs': 'Starý židovský hřbitov',
      },
    ],
    coordinates: '50.0881, 14.4179',
    notes: [
      {
        'en': 'Station located beneath Kaprova street in Prague Old Town.',
        'ru': 'Станция расположена под улицей Капрова в Старом городе Праги.',
        'cs': 'Stanice se nachází pod Kaprovou ulicí na Starém Městě.',
      },
      {
        'en': 'Opened in 1978 as part of the inaugural Line A segment.',
        'ru': 'Открыта в 1978 году как часть первого участка линии A.',
        'cs': 'Otevřena v roce 1978 jako součást prvního úseku linky A.',
      },
      {
        'en': 'A second planned entrance near Old Town Square was never completed.',
        'ru': 'Второй планируемый выход возле Староместской площади так и не был построен.',
        'cs': 'Druhý plánovaný vstup poblíž Staroměstského náměstí nebyl nikdy dokončen.',
      },
    ],
    sources: [
      'https://www.dpp.cz/en',
      'https://pid.cz/en/metro/',
      'https://cs.wikipedia.org/wiki/Starom%C4%9Bstsk%C3%A1_%28stanice_metra%29',
      'https://en.wikipedia.org/wiki/Starom%C4%9Bstsk%C3%A1_%28Prague_Metro%29',
      'https://mapy.com/cs/?id=15305969&source=pubt',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'mustek_a': _mustekDetails,
  'mustek_b': _mustekBDetails,
  'muzeum_a': _muzeumDetails,
  'muzeum_c': _muzeumCDetails,
  'namesti_miru': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Náměstí Míru square',
          'ru': 'Площадь Мира',
          'cs': 'Náměstí Míru',
        },
        details: {
          'en': 'Single main exit toward Church of St. Ludmila and Vinohrady Theatre.',
          'ru': 'Единственный главный выход к костёлу Святой Людмилы и театру Винограды.',
          'cs': 'Jediný hlavní výstup směrem ke kostelu sv. Ludmily a Divadlu na Vinohradech.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Church of St. Ludmila',
        'ru': 'Костёл Святой Людмилы',
        'cs': 'Kostel svaté Ludmily',
      },
      {
        'en': 'Vinohrady Theatre',
        'ru': 'Театр Винограды',
        'cs': 'Divadlo na Vinohradech',
      },
      {
        'en': 'Vinohrady district',
        'ru': 'Район Винограды',
        'cs': 'Vinohrady',
      },
    ],
    coordinates: '50.0754, 14.4378',
    notes: [
      {
        'en': 'Deepest station in the Prague Metro network at approximately 53 meters.',
        'ru': 'Самая глубокая станция пражского метро — около 53 метров.',
        'cs': 'Nejhlubší stanice pražského metra s hloubkou přibližně 53 metrů.',
      },
      {
        'en': 'Features one of the longest escalators in the European Union.',
        'ru': 'Имеет один из самых длинных эскалаторов в Европейском союзе.',
        'cs': 'Má jeden z nejdelších eskalátorů v Evropské unii.',
      },
      {
        'en': 'Served as Line A terminus from 1978 to 1980.',
        'ru': 'Была конечной станцией линии A с 1978 по 1980 год.',
        'cs': 'V letech 1978–1980 byla konečnou stanicí linky A.',
      },
    ],
    sources: [
      'https://www.dpp.cz/en',
      'https://pid.cz/en/metro/',
      'https://en.wikipedia.org/wiki/N%C3%A1m%C4%9Bst%C3%AD_M%C3%ADru_(Prague_Metro)',
      'https://mapy.com/en/?id=15305996&source=pubt',
      'https://metroprague.com/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'jiriho_z_podebrad': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Jiřího z Poděbrad Square',
          'ru': 'Площадь Иржи из Подебрад',
          'cs': 'Náměstí Jiřího z Poděbrad',
        },
        details: {
          'en': 'Main exit toward the square, church, cafés, and local markets.',
          'ru': 'Главный выход к площади, церкви, кафе и местным рынкам.',
          'cs': 'Hlavní výstup směrem na náměstí, ke kostelu, kavárnám a místním trhům.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Church of the Most Sacred Heart of Our Lord',
        'ru': 'Церковь Пресвятого Сердца Господня',
        'cs': 'Kostel Nejsvětějšího Srdce Páně',
      },
      {
        'en': 'Jiřího z Poděbrad Square',
        'ru': 'Площадь Иржи из Подебрад',
        'cs': 'Náměstí Jiřího z Poděbrad',
      },
      {
        'en': 'Vinohrady district',
        'ru': 'Район Винограды',
        'cs': 'Vinohrady',
      },
    ],
    coordinates: '50.0785, 14.4508',
    notes: [
      {
        'en': 'Opened in 1980 as part of the extension from Náměstí Míru to Želivského.',
        'ru': 'Открыта в 1980 году как часть продления от Náměstí Míru до Želivského.',
        'cs': 'Otevřena v roce 1980 jako součást prodloužení z Náměstí Míru do Želivského.',
      },
      {
        'en': 'Station underwent major reconstruction between 2023 and 2024.',
        'ru': 'Станция прошла масштабную реконструкцию в 2023–2024 годах.',
        'cs': 'Stanice prošla rozsáhlou rekonstrukcí v letech 2023–2024.',
      },
      {
        'en': 'Barrier-free elevators entered operation in 2024.',
        'ru': 'Лифты для безбарьерного доступа введены в эксплуатацию в 2024 году.',
        'cs': 'Bezbariérové výtahy byly uvedeny do provozu v roce 2024.',
      },
    ],
    sources: [
      'https://www.dpp.cz/en/company/news/detail/342_2694-jiriho-z-podebrad-is-the-47th-barrier-free-metro-station',
      'https://pid.cz/en/metro/',
      'https://en.wikipedia.org/wiki/Ji%C5%99%C3%ADho_z_Pod%C4%9Bbrad_(Prague_Metro)',
      'https://www.praha3.cz/aktualne-z-trojky/o-praze-3/naucna-stezka-prahy-3/namesti-jiriho-z-podebrad/eng',
      'https://www.satescechy.cz/en/realizace/jiriho-z-podebrad-metro-station/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'flora': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Atrium Flora shopping center',
          'ru': 'Торговый центр Atrium Flora',
          'cs': 'Atrium Flora',
        },
        details: {
          'en': 'Main exit toward shopping mall, Vinohradská street, and tram stops.',
          'ru': 'Главный выход к торговому центру, улице Виноградска и трамвайным остановкам.',
          'cs': 'Hlavní výstup směrem k obchodnímu centru, Vinohradské třídě a tramvajovým zastávkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Atrium Flora',
        'ru': 'Atrium Flora',
        'cs': 'Atrium Flora',
      },
      {
        'en': 'Olšany Cemetery',
        'ru': 'Ольшанское кладбище',
        'cs': 'Olšanské hřbitovy',
      },
      {
        'en': 'Vinohrady district',
        'ru': 'Район Винограды',
        'cs': 'Vinohrady',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['136', '175'],
      trams: ['5', '10', '11', '16'],
    ),
    coordinates: '50.0789, 14.4612',
    notes: [
      {
        'en': 'Opened in 1980 as part of the extension from Náměstí Míru to Želivského.',
        'ru': 'Открыта в 1980 году как часть продления от Náměstí Míru до Želivského.',
        'cs': 'Otevřena v roce 1980 jako součást prodloužení z Náměstí Míru do Želivského.',
      },
      {
        'en': 'Located beneath the Atrium Flora shopping complex area.',
        'ru': 'Расположена под районом торгового комплекса Atrium Flora.',
        'cs': 'Nachází se pod oblastí obchodního centra Atrium Flora.',
      },
      {
        'en': 'Major renovation and accessibility upgrade started in 2026.',
        'ru': 'Крупная реконструкция и модернизация доступности началась в 2026 году.',
        'cs': 'Rozsáhlá rekonstrukce a modernizace bezbariérovosti začala v roce 2026.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Flora_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://czech-transport.com/index.php?id=536',
      'https://www.expats.cz/czech-news/article/prague-transport-alert-flora-metro-station-to-close-for-10-months',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'zelivskeho': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Vinohradská street',
          'ru': 'Улица Виноградска',
          'cs': 'Vinohradská',
        },
        details: {
          'en': 'Main exits toward tram stops, regional bus terminal, and Olšany Cemetery.',
          'ru': 'Главные выходы к трамвайным остановкам, региональному автобусному терминалу и Ольшанскому кладбищу.',
          'cs': 'Hlavní výstupy směrem k tramvajím, regionálnímu autobusovému terminálu a Olšanským hřbitovům.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Olšany Cemetery',
        'ru': 'Ольшанское кладбище',
        'cs': 'Olšanské hřbitovy',
      },
      {
        'en': 'Žižkov district',
        'ru': 'Район Жижков',
        'cs': 'Žižkov',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['124', '134', '135', '139', '155', '188', '213', '234'],
      trams: ['10', '11', '16', '19', '26'],
      other: [
        {
          'en': 'Regional bus terminal',
          'ru': 'Региональный автобусный терминал',
          'cs': 'Regionální autobusový terminál',
        },
      ],
    ),
    coordinates: '50.0781, 14.4750',
    notes: [
      {
        'en': 'Opened in 1980 and served as eastern terminus of Line A until 1987.',
        'ru': 'Открыта в 1980 году и была восточной конечной линии A до 1987 года.',
        'cs': 'Otevřena v roce 1980 a do roku 1987 byla východní konečnou linky A.',
      },
      {
        'en': 'Station located beneath Vinohradská street near Olšany Cemetery.',
        'ru': 'Станция расположена под улицей Виноградска рядом с Ольшанским кладбищем.',
        'cs': 'Stanice se nachází pod Vinohradskou ulicí poblíž Olšanských hřbitovů.',
      },
      {
        'en': 'Original Line A interior design remains largely preserved.',
        'ru': 'Оригинальный интерьер линии A в основном сохранился.',
        'cs': 'Původní interiér linky A je z velké části zachován.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/%C5%BDelivsk%C3%A9ho_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://czech-transport.com/index.php?id=536',
      'https://www.metrolinemap.com/station/prague/zelivskeho/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'strasnicka': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Starostrašnická street',
          'ru': 'Улица Старострашницка',
          'cs': 'Starostrašnická',
        },
        details: {
          'en': 'Single concourse exit toward tram stops and Strašnice neighborhood.',
          'ru': 'Единственный выход к трамвайным остановкам и району Страшнице.',
          'cs': 'Jediný výstup směrem k tramvajovým zastávkám a čtvrti Strašnice.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Strašnice district',
        'ru': 'Район Страшнице',
        'cs': 'Strašnice',
      },
      {
        'en': 'Strašnice tram depot area',
        'ru': 'Район трамвайного депо Страшнице',
        'cs': 'Oblast vozovny Strašnice',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['175', '188', '224'],
      trams: ['7', '19', '26'],
    ),
    coordinates: '50.0727, 14.4909',
    notes: [
      {
        'en': 'Opened in 1987 as eastern terminus of Line A extension from Želivského.',
        'ru': 'Открыта в 1987 году как восточная конечная продления линии A от Želivského.',
        'cs': 'Otevřena v roce 1987 jako východní konečná prodloužení linky A ze Želivského.',
      },
      {
        'en': 'Line A was extended further to Skalka in 1990.',
        'ru': 'В 1990 году линия A была продлена до Skalka.',
        'cs': 'V roce 1990 byla linka A prodloužena do Skalky.',
      },
      {
        'en': 'Shallow station approximately 7.5 meters below surface level.',
        'ru': 'Неглубокая станция — примерно 7,5 метров под землёй.',
        'cs': 'Mělká stanice přibližně 7,5 metru pod povrchem.',
      },
      {
        'en': 'Barrier-free access available.',
        'ru': 'Доступна безбарьерная среда.',
        'cs': 'Bezbariérový přístup k dispozici.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Stra%C5%A1nick%C3%A1_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://czech-transport.com/index.php?id=536',
      'https://mapy.com/cs/?id=15305961&source=pubt',
      'https://www.metrolinemap.com/station/prague/strasnicka/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'skalka': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Na Padesátém street',
          'ru': 'Улица Na Padesátém',
          'cs': 'Na Padesátém',
        },
        details: {
          'en': 'Main exit toward residential areas, tram stops, and bus terminal.',
          'ru': 'Главный выход к жилым районам, трамвайным остановкам и автобусному терминалу.',
          'cs': 'Hlavní výstup směrem k obytným oblastem, tramvajovým zastávkám a autobusovému terminálu.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Strašnice district',
        'ru': 'Район Страшнице',
        'cs': 'Strašnice',
      },
      {
        'en': 'Skalka shopping area',
        'ru': 'Торговая зона Skalka',
        'cs': 'Obchodní oblast Skalka',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['125', '138', '175', '177', '195'],
      trams: ['22', '26'],
    ),
    coordinates: '50.0684, 14.5072',
    notes: [
      {
        'en': 'Opened in 1990 as eastern extension of Line A.',
        'ru': 'Открыта в 1990 году как восточное продление линии A.',
        'cs': 'Otevřena v roce 1990 jako východní prodloužení linky A.',
      },
      {
        'en': 'Served as eastern terminus of Line A until 2006.',
        'ru': 'Была восточной конечной линии A до 2006 года.',
        'cs': 'Do roku 2006 byla východní konečnou linky A.',
      },
      {
        'en': 'Barrier-free access available.',
        'ru': 'Доступна безбарьерная среда.',
        'cs': 'Bezbariérový přístup k dispozici.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Skalka_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
      'https://mapy.com/en/?id=15305954&source=pubt',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'depo_hostivar': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Černokostelecká street',
          'ru': 'Улица Чернокостелецка',
          'cs': 'Černokostelecká',
        },
        details: {
          'en': 'Main exit toward Park & Ride, bus terminal, and depot facilities.',
          'ru': 'Главный выход к Park & Ride, автобусному терминалу и депо.',
          'cs': 'Hlavní výstup směrem k P+R parkovišti, autobusovému terminálu a depu.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Hostivař Depot',
        'ru': 'Депо Гостиварж',
        'cs': 'Depo Hostivař',
      },
      {
        'en': 'Park and Ride facility',
        'ru': 'Парковка Park and Ride',
        'cs': 'Parkoviště P+R',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['163', '208', '223', '228', '229', '364', '366'],
      other: [
        {
          'en': 'Park & Ride parking',
          'ru': 'Парковка Park & Ride',
          'cs': 'Parkoviště P+R',
        },
      ],
    ),
    coordinates: '50.0756, 14.5159',
    notes: [
      {
        'en': 'Eastern terminus of Line A since 2006.',
        'ru': 'Восточная конечная линии A с 2006 года.',
        'cs': 'Východní konečná linky A od roku 2006.',
      },
      {
        'en': 'Built partially above ground inside depot premises.',
        'ru': 'Построена частично над землёй на территории депо.',
        'cs': 'Postavena částečně nad zemí v areálu depa.',
      },
      {
        'en': 'One of the few Prague Metro stations with daylight access to platforms.',
        'ru': 'Одна из немногих станций метро Праги с естественным освещением платформ.',
        'cs': 'Jedna z mála stanic pražského metra s denním světlem na nástupišti.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Depo_Hostiva%C5%99_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
      'https://mapy.com/en/?id=15305951&source=pubt',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'zlicin': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Řevnická street',
          'ru': 'Улица Ржевницка',
          'cs': 'Řevnická',
        },
        details: {
          'en': 'Main exit toward shopping centers, bus terminal, and Park & Ride.',
          'ru': 'Главный выход к торговым центрам, автобусному терминалу и Park & Ride.',
          'cs': 'Hlavní výstup směrem k obchodním centrům, autobusovému terminálu a parkovišti P+R.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Metropole Zličín',
        'ru': 'Metropole Zličín',
        'cs': 'Metropole Zličín',
      },
      {
        'en': 'IKEA Zličín',
        'ru': 'IKEA Zličín',
        'cs': 'IKEA Zličín',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['100', '164', '180', '246', '347', '384'],
      other: [
        {
          'en': 'Regional bus terminal',
          'ru': 'Региональный автобусный терминал',
          'cs': 'Regionální autobusový terminál',
        },
        {
          'en': 'Park & Ride parking',
          'ru': 'Парковка Park & Ride',
          'cs': 'Parkoviště P+R',
        },
      ],
    ),
    coordinates: '50.0508, 14.2910',
    notes: [
      {
        'en': 'Western terminus of Line B.',
        'ru': 'Западная конечная линии B.',
        'cs': 'Západní konečná linky B.',
      },
      {
        'en': 'Opened in 1994 as part of the extension from Nové Butovice.',
        'ru': 'Открыта в 1994 году как часть продления от Nové Butovice.',
        'cs': 'Otevřena v roce 1994 jako součást prodloužení z Nových Butovic.',
      },
      {
        'en': 'Important interchange for airport bus services.',
        'ru': 'Важный пересадочный узел для автобусных маршрутов в аэропорт.',
        'cs': 'Významný přestupní uzel pro autobusové linky na letiště.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Zli%C4%8D%C3%ADn_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
      'https://mapy.com/en/?id=15306068&source=pubt',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'stodulky': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Mukařovského street',
          'ru': 'Улица Мукаржовскего',
          'cs': 'Mukařovského',
        },
        details: {
          'en': 'Exit toward residential district and local bus connections.',
          'ru': 'Выход к жилому району и местным автобусным маршрутам.',
          'cs': 'Výstup směrem k obytné čtvrti a místním autobusovým linkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Stodůlky residential district',
        'ru': 'Жилой район Стодулки',
        'cs': 'Sídliště Stodůlky',
      },
      {
        'en': 'Central Park Prague',
        'ru': 'Central Park Prague',
        'cs': 'Central Park Praha',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['142', '184', '225'],
    ),
    coordinates: '50.0464, 14.3217',
    notes: [
      {
        'en': 'Opened in 1994 as part of the western extension of Line B.',
        'ru': 'Открыта в 1994 году как часть западного продления линии B.',
        'cs': 'Otevřena v roce 1994 jako součást západního prodloužení linky B.',
      },
      {
        'en': 'Station serves large residential housing estates.',
        'ru': 'Станция обслуживает крупные жилые массивы.',
        'cs': 'Stanice obsluhuje rozsáhlá sídliště.',
      },
      {
        'en': 'Shallow underground station with island platform.',
        'ru': 'Неглубокая подземная станция с островной платформой.',
        'cs': 'Mělká podzemní stanice s ostrovním nástupištěm.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Stod%C5%AFlky_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
      'https://mapy.com/en/?id=15306058&source=pubt',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'luka': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Mukařovského street',
          'ru': 'Улица Мукаржовскего',
          'cs': 'Mukařovského',
        },
        details: {
          'en': 'Exit toward residential housing estates and nearby bus stops.',
          'ru': 'Выход к жилым кварталам и ближайшим автобусным остановкам.',
          'cs': 'Výstup směrem k obytným sídlištím a blízkým autobusovým zastávkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Central Park Prague',
        'ru': 'Central Park Prague',
        'cs': 'Central Park Praha',
      },
      {
        'en': 'Stodůlky residential district',
        'ru': 'Жилой район Стодулки',
        'cs': 'Sídliště Stodůlky',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['174', '225'],
    ),
    coordinates: '50.0451, 14.3229',
    notes: [
      {
        'en': 'Opened in 1994 during the western extension of Line B.',
        'ru': 'Открыта в 1994 году во время западного продления линии B.',
        'cs': 'Otevřena v roce 1994 při západním prodloužení linky B.',
      },
      {
        'en': 'Shallow underground station with island platform.',
        'ru': 'Неглубокая подземная станция с островной платформой.',
        'cs': 'Mělká podzemní stanice s ostrovním nástupištěm.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Luka_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'luziny': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Archeologická street',
          'ru': 'Улица Археологицка',
          'cs': 'Archeologická',
        },
        details: {
          'en': 'Main exit toward shopping area and residential district.',
          'ru': 'Главный выход к торговой зоне и жилому району.',
          'cs': 'Hlavní výstup směrem k obchodní oblasti a obytné čtvrti.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Lužiny shopping center',
        'ru': 'Торговый центр Lužiny',
        'cs': 'Obchodní centrum Lužiny',
      },
      {
        'en': 'Stodůlky district',
        'ru': 'Район Стодулки',
        'cs': 'Stodůlky',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['142', '184', '301', '352'],
    ),
    coordinates: '50.0447, 14.3310',
    notes: [
      {
        'en': 'Opened in 1994 as part of the extension from Nové Butovice to Zličín.',
        'ru': 'Открыта в 1994 году как часть продления от Nové Butovice до Zličín.',
        'cs': 'Otevřena v roce 1994 jako součást prodloužení z Nových Butovic do Zličína.',
      },
      {
        'en': 'Station serves large residential and shopping areas.',
        'ru': 'Станция обслуживает крупные жилые и торговые районы.',
        'cs': 'Stanice obsluhuje rozsáhlé obytné a obchodní oblasti.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Lu%C5%BEiny_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'hurka': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Sluneční náměstí',
          'ru': 'Площадь Sluneční',
          'cs': 'Sluneční náměstí',
        },
        details: {
          'en': 'Exit toward office complexes, residential buildings, and bus stops.',
          'ru': 'Выход к офисным комплексам, жилым зданиям и автобусным остановкам.',
          'cs': 'Výstup směrem k administrativním komplexům, obytným budovám a autobusovým zastávkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Sluneční náměstí',
        'ru': 'Площадь Sluneční',
        'cs': 'Sluneční náměstí',
      },
      {
        'en': 'Prague 13 municipal offices',
        'ru': 'Муниципальные офисы Праги 13',
        'cs': 'Úřad městské části Praha 13',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['149', '174', '184', '225'],
    ),
    coordinates: '50.0491, 14.3434',
    notes: [
      {
        'en': 'Opened in 1994 during the western expansion of Line B.',
        'ru': 'Открыта в 1994 году во время западного расширения линии B.',
        'cs': 'Otevřena v roce 1994 během západního rozšíření linky B.',
      },
      {
        'en': 'Station architecture includes natural lighting elements.',
        'ru': 'Архитектура станции включает элементы естественного освещения.',
        'cs': 'Architektura stanice zahrnuje prvky přirozeného osvětlení.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/H%C5%AFrka_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'nove_butovice': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Bucharova street',
          'ru': 'Улица Бухарова',
          'cs': 'Bucharova',
        },
        details: {
          'en': 'Main exit toward office district, bus terminal, and shopping facilities.',
          'ru': 'Главный выход к офисному району, автобусному терминалу и торговым объектам.',
          'cs': 'Hlavní výstup směrem k administrativní čtvrti, autobusovému terminálu a obchodům.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Prague 13 district offices',
        'ru': 'Администрация района Прага 13',
        'cs': 'Úřad městské části Praha 13',
      },
      {
        'en': 'Butovice business zone',
        'ru': 'Деловая зона Butovice',
        'cs': 'Administrativní zóna Butovice',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['137', '149', '168', '184', '225'],
      other: [
        {
          'en': 'Regional bus connections',
          'ru': 'Региональные автобусные маршруты',
          'cs': 'Regionální autobusové spoje',
        },
      ],
    ),
    coordinates: '50.0504, 14.3527',
    notes: [
      {
        'en': 'Served as western terminus of Line B from 1988 to 1994.',
        'ru': 'Была западной конечной линии B с 1988 по 1994 год.',
        'cs': 'V letech 1988–1994 byla západní konečnou linky B.',
      },
      {
        'en': 'Major office and residential development surrounds the station.',
        'ru': 'Станцию окружают крупные офисные и жилые комплексы.',
        'cs': 'Stanici obklopuje rozsáhlá kancelářská a obytná výstavba.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Nov%C3%A9_Butovice_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'jinonice': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Radlická street',
          'ru': 'Улица Радлицка',
          'cs': 'Radlická',
        },
        details: {
          'en': 'Exit toward Waltrovka district, office buildings, and local bus stops.',
          'ru': 'Выход к району Waltrovka, офисным зданиям и местным автобусным остановкам.',
          'cs': 'Výstup směrem k čtvrti Waltrovka, kancelářským budovám a autobusovým zastávkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Waltrovka business district',
        'ru': 'Деловой район Waltrovka',
        'cs': 'Administrativní čtvrť Waltrovka',
      },
      {
        'en': 'Jinonice district',
        'ru': 'Район Йинонице',
        'cs': 'Jinonice',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['137', '149'],
    ),
    coordinates: '50.0541, 14.3712',
    notes: [
      {
        'en': 'Opened in 1988 as part of the extension from Smíchovské nádraží.',
        'ru': 'Открыта в 1988 году как часть продления от Smíchovské nádraží.',
        'cs': 'Otevřena v roce 1988 jako součást prodloužení ze Smíchovského nádraží.',
      },
      {
        'en': 'Station area underwent significant redevelopment after construction of Waltrovka.',
        'ru': 'Район станции значительно изменился после строительства Waltrovka.',
        'cs': 'Oblast stanice prošla výraznou proměnou po výstavbě Waltrovky.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Jinonice_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'radlicka': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Radlická street',
          'ru': 'Улица Радлицка',
          'cs': 'Radlická',
        },
        details: {
          'en': 'Main exit toward office buildings, bus terminal, and Radlice district.',
          'ru': 'Главный выход к офисным зданиям, автобусному терминалу и району Радлице.',
          'cs': 'Hlavní výstup směrem k administrativním budovám, autobusovému terminálu a čtvrti Radlice.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'ČSOB Headquarters',
        'ru': 'Штаб-квартира ČSOB',
        'cs': 'Sídlo ČSOB',
      },
      {
        'en': 'Radlice district',
        'ru': 'Район Радлице',
        'cs': 'Radlice',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['137', '149', '226'],
    ),
    coordinates: '50.0582, 14.3897',
    notes: [
      {
        'en': 'Opened in 1988 as part of the Line B extension from Smíchovské nádraží.',
        'ru': 'Открыта в 1988 году как часть продления линии B от Smíchovské nádraží.',
        'cs': 'Otevřena v roce 1988 jako součást prodloužení linky B ze Smíchovského nádraží.',
      },
      {
        'en': 'Station is located in a valley area with surrounding office development.',
        'ru': 'Станция расположена в долине с окружающей офисной застройкой.',
        'cs': 'Stanice se nachází v údolní oblasti s okolní administrativní výstavbou.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Radlick%C3%A1_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'smichovske_nadrazi': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Smíchov railway station',
          'ru': 'Смиховский железнодорожный вокзал',
          'cs': 'Smíchovské nádraží',
        },
        details: {
          'en': 'Direct access to railway station, bus terminal, and tram interchange.',
          'ru': 'Прямой доступ к железнодорожному вокзалу, автобусному терминалу и трамвайному узлу.',
          'cs': 'Přímý přístup k železniční stanici, autobusovému terminálu a tramvajovému uzlu.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Praha-Smíchov railway station',
        'ru': 'Железнодорожный вокзал Praha-Smíchov',
        'cs': 'Nádraží Praha-Smíchov',
      },
      {
        'en': 'Smíchov district',
        'ru': 'Район Смихов',
        'cs': 'Smíchov',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['120', '125', '129', '191', '241'],
      trams: ['4', '5', '7', '12', '14', '20'],
      other: [
        {
          'en': 'Railway connection',
          'ru': 'Железнодорожное сообщение',
          'cs': 'Železniční spojení',
        },
        {
          'en': 'Regional and long-distance bus terminal',
          'ru': 'Региональный и междугородний автобусный терминал',
          'cs': 'Regionální a dálkový autobusový terminál',
        },
      ],
    ),
    coordinates: '50.0617, 14.4085',
    notes: [
      {
        'en': 'Major transfer station between metro, rail, tram, and bus services.',
        'ru': 'Крупный пересадочный узел между метро, железной дорогой, трамваями и автобусами.',
        'cs': 'Významný přestupní uzel mezi metrem, železnicí, tramvajemi a autobusy.',
      },
      {
        'en': 'Western terminus of Line B from 1985 to 1988.',
        'ru': 'Была западной конечной линии B с 1985 по 1988 год.',
        'cs': 'V letech 1985–1988 byla západní konečnou linky B.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Sm%C3%ADchovsk%C3%A9_n%C3%A1dra%C5%BE%C3%AD_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'andel': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Anděl / Nádražní street',
          'ru': 'Андел / улица Надражни',
          'cs': 'Anděl / Nádražní',
        },
        details: {
          'en': 'Main exits toward shopping centers, tram hub, and pedestrian zone.',
          'ru': 'Главные выходы к торговым центрам, трамвайному узлу и пешеходной зоне.',
          'cs': 'Hlavní výstupy směrem k obchodním centrům, tramvajovému uzlu a pěší zóně.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Nový Smíchov shopping center',
        'ru': 'Торговый центр Nový Smíchov',
        'cs': 'Nový Smíchov',
      },
      {
        'en': 'Anděl business district',
        'ru': 'Деловой район Anděl',
        'cs': 'Administrativní oblast Anděl',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['123', '167', '191'],
      trams: ['4', '5', '7', '9', '10', '12', '14', '15', '16', '20', '21'],
    ),
    coordinates: '50.0707, 14.4031',
    notes: [
      {
        'en': 'Station was named Moskevská before 1990.',
        'ru': 'До 1990 года станция называлась Moskevská.',
        'cs': 'Do roku 1990 nesla stanice název Moskevská.',
      },
      {
        'en': 'One of Prague’s busiest public transport hubs.',
        'ru': 'Один из самых загруженных транспортных узлов Праги.',
        'cs': 'Jeden z nejvytíženějších dopravních uzlů v Praze.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/And%C4%9Bl_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'karlovo_namesti': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Karlovo Square',
          'ru': 'Карлова площадь',
          'cs': 'Karlovo náměstí',
        },
        details: {
          'en': 'Exits toward Karlovo Square, New Town, and tram stops.',
          'ru': 'Выходы к Карловой площади, Новому городу и трамвайным остановкам.',
          'cs': 'Výstupy směrem na Karlovo náměstí, Nové Město a tramvajové zastávky.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Karlovo Square',
        'ru': 'Карлова площадь',
        'cs': 'Karlovo náměstí',
      },
      {
        'en': 'New Town Hall',
        'ru': 'Новая ратуша',
        'cs': 'Novoměstská radnice',
      },
    ],
    nearbyTransport: NearbyTransport(
      trams: ['3', '4', '10', '14', '16', '18', '22', '24'],
    ),
    coordinates: '50.0755, 14.4183',
    notes: [
      {
        'en': 'Opened in 1985 with the first section of Line B.',
        'ru': 'Открыта в 1985 году вместе с первым участком линии B.',
        'cs': 'Otevřena v roce 1985 s prvním úsekem linky B.',
      },
      {
        'en': 'One of the deepest stations on Line B.',
        'ru': 'Одна из самых глубоких станций линии B.',
        'cs': 'Jedna z nejhlubších stanic linky B.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Karlovo_n%C3%A1m%C4%9Bst%C3%AD_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'narodni_trida': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Národní avenue',
          'ru': 'Проспект Народни',
          'cs': 'Národní třída',
        },
        details: {
          'en': 'Main exits toward National Theatre, shopping streets, and tram stops.',
          'ru': 'Главные выходы к Национальному театру, торговым улицам и трамвайным остановкам.',
          'cs': 'Hlavní výstupy směrem k Národnímu divadlu, obchodním ulicím a tramvajovým zastávkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'National Theatre',
        'ru': 'Национальный театр',
        'cs': 'Národní divadlo',
      },
      {
        'en': 'Quadrio shopping center',
        'ru': 'Торговый центр Quadrio',
        'cs': 'Obchodní centrum Quadrio',
      },
      {
        'en': 'Old Town',
        'ru': 'Старый город',
        'cs': 'Staré Město',
      },
    ],
    nearbyTransport: NearbyTransport(
      trams: ['2', '9', '18', '22'],
    ),
    coordinates: '50.0810, 14.4206',
    notes: [
      {
        'en': 'Station significantly renovated between 2012 and 2015.',
        'ru': 'Станция была значительно реконструирована в 2012–2015 годах.',
        'cs': 'Stanice prošla rozsáhlou rekonstrukcí v letech 2012–2015.',
      },
      {
        'en': 'Named after the historic Národní avenue.',
        'ru': 'Названа в честь исторического проспекта Народни.',
        'cs': 'Pojmenována podle historické Národní třídy.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/N%C3%A1rodn%C3%AD_t%C5%99%C3%ADda_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'namesti_republiky': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Republic Square',
          'ru': 'Площадь Республики',
          'cs': 'Náměstí Republiky',
        },
        details: {
          'en': 'Exits toward Palladium shopping center, Municipal House, and Old Town.',
          'ru': 'Выходы к торговому центру Palladium, Муниципальному дому и Старому городу.',
          'cs': 'Výstupy směrem k obchodnímu centru Palladium, Obecnímu domu a Starému Městu.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Palladium shopping center',
        'ru': 'Торговый центр Palladium',
        'cs': 'Palladium',
      },
      {
        'en': 'Municipal House',
        'ru': 'Муниципальный дом',
        'cs': 'Obecní dům',
      },
      {
        'en': 'Powder Tower',
        'ru': 'Пороховая башня',
        'cs': 'Prašná brána',
      },
    ],
    nearbyTransport: NearbyTransport(
      trams: ['6', '8', '15', '26'],
    ),
    coordinates: '50.0886, 14.4295',
    notes: [
      {
        'en': 'Located beneath Republic Square near Prague Old Town.',
        'ru': 'Расположена под площадью Республики рядом со Старым городом Праги.',
        'cs': 'Nachází se pod Náměstím Republiky poblíž Starého Města.',
      },
      {
        'en': 'Opened in 1985 with the first operational section of Line B.',
        'ru': 'Открыта в 1985 году вместе с первым участком линии B.',
        'cs': 'Otevřena v roce 1985 s prvním provozním úsekem linky B.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/N%C3%A1m%C4%9Bst%C3%AD_Republiky_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'florenc_b': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Florenc bus terminal',
          'ru': 'Автовокзал Флоренц',
          'cs': 'Autobusové nádraží Florenc',
        },
        details: {
          'en': 'Main exits toward international bus terminal, railway stations, and Line C transfer.',
          'ru': 'Главные выходы к международному автовокзалу, железнодорожным станциям и переходу на линию C.',
          'cs': 'Hlavní výstupy směrem k mezinárodnímu autobusovému nádraží, železničním stanicím a přestupu na linku C.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Florenc Central Bus Station',
        'ru': 'Центральный автовокзал Флоренц',
        'cs': 'ÚAN Florenc',
      },
      {
        'en': 'Karlín district',
        'ru': 'Район Карлин',
        'cs': 'Karlín',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['133', '135', '175', '207'],
      trams: ['3', '8', '24'],
      other: [
        {
          'en': 'Transfer to Metro Line C',
          'ru': 'Переход на линию метро C',
          'cs': 'Přestup na linku metra C',
        },
        {
          'en': 'International bus terminal',
          'ru': 'Международный автобусный терминал',
          'cs': 'Mezinárodní autobusový terminál',
        },
      ],
    ),
    coordinates: '50.0909, 14.4395',
    notes: [
      {
        'en': 'One of Prague’s busiest interchange stations.',
        'ru': 'Одна из самых загруженных пересадочных станций Праги.',
        'cs': 'Jedna z nejvytíženějších přestupních stanic v Praze.',
      },
      {
        'en': 'Transfer station between Lines B and C.',
        'ru': 'Пересадочная станция между линиями B и C.',
        'cs': 'Přestupní stanice mezi linkami B a C.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Florenc_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'krizikova': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Sokolovská street',
          'ru': 'Улица Соколовска',
          'cs': 'Sokolovská',
        },
        details: {
          'en': 'Exits toward Karlín district and tram stops.',
          'ru': 'Выходы к району Карлин и трамвайным остановкам.',
          'cs': 'Výstupy směrem do Karlína a k tramvajovým zastávkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Karlín district',
        'ru': 'Район Карлин',
        'cs': 'Karlín',
      },
      {
        'en': 'Forum Karlín',
        'ru': 'Forum Karlín',
        'cs': 'Forum Karlín',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['133', '207'],
      trams: ['3', '8', '24'],
    ),
    coordinates: '50.0924, 14.4505',
    notes: [
      {
        'en': 'Named after Czech inventor František Křižík.',
        'ru': 'Названа в честь чешского изобретателя Франтишека Кржижика.',
        'cs': 'Pojmenována po českém vynálezci Františku Křižíkovi.',
      },
      {
        'en': 'Station serves the revitalized Karlín district.',
        'ru': 'Станция обслуживает обновлённый район Карлин.',
        'cs': 'Stanice obsluhuje revitalizovanou čtvrť Karlín.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/K%C5%99%C3%AD%C5%BE%C3%ADkova_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'invalidovna': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Sokolovská street',
          'ru': 'Улица Соколовска',
          'cs': 'Sokolovská',
        },
        details: {
          'en': 'Main exits toward Invalidovna complex and Karlín residential area.',
          'ru': 'Главные выходы к комплексу Invalidovna и жилому району Карлин.',
          'cs': 'Hlavní výstupy směrem k Invalidovně a obytné části Karlína.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Invalidovna historical building',
        'ru': 'Историческое здание Invalidovna',
        'cs': 'Historická budova Invalidovna',
      },
      {
        'en': 'Karlín district',
        'ru': 'Район Карлин',
        'cs': 'Karlín',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['136', '177', '195'],
      trams: ['3', '8', '24'],
    ),
    coordinates: '50.0948, 14.4631',
    notes: [
      {
        'en': 'Named after the nearby Baroque Invalidovna complex.',
        'ru': 'Названа в честь расположенного рядом барочного комплекса Invalidovna.',
        'cs': 'Pojmenována podle nedalekého barokního komplexu Invalidovna.',
      },
      {
        'en': 'Opened in 1990 as part of the extension toward Českomoravská.',
        'ru': 'Открыта в 1990 году как часть продления в сторону Českomoravská.',
        'cs': 'Otevřena v roce 1990 jako součást prodloužení směrem k Českomoravské.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Invalidovna_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'palmovka': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Sokolovská street',
          'ru': 'Улица Соколовска',
          'cs': 'Sokolovská',
        },
        details: {
          'en': 'Main exits toward tram hub, bus terminal, and Libeň district.',
          'ru': 'Главные выходы к трамвайному узлу, автобусному терминалу и району Либень.',
          'cs': 'Hlavní výstupy směrem k tramvajovému uzlu, autobusovému terminálu a čtvrti Libeň.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Palmovka transport hub',
        'ru': 'Транспортный узел Palmovka',
        'cs': 'Dopravní uzel Palmovka',
      },
      {
        'en': 'Libeň district',
        'ru': 'Район Либень',
        'cs': 'Libeň',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['109', '140', '185', '302'],
      trams: ['1', '3', '10', '24', '25'],
    ),
    coordinates: '50.1035, 14.4740',
    notes: [
      {
        'en': 'Opened in 1990 as part of the extension toward Českomoravská.',
        'ru': 'Открыта в 1990 году как часть продления в сторону Českomoravská.',
        'cs': 'Otevřena v roce 1990 jako součást prodloužení směrem k Českomoravské.',
      },
      {
        'en': 'One of the busiest public transport interchanges outside Prague city center.',
        'ru': 'Один из самых загруженных транспортных узлов вне центра Праги.',
        'cs': 'Jeden z nejvytíženějších dopravních uzlů mimo centrum Prahy.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Palmovka_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'ceskomoravska': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'O2 Arena / Harfa',
          'ru': 'O2 Arena / Harfa',
          'cs': 'O2 arena / Harfa',
        },
        details: {
          'en': 'Exits toward O2 Arena, Galerie Harfa, and event venues.',
          'ru': 'Выходы к O2 Arena, Galerie Harfa и концертным площадкам.',
          'cs': 'Výstupy směrem k O2 areně, Galerii Harfa a kulturním akcím.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'O2 Arena',
        'ru': 'O2 Arena',
        'cs': 'O2 arena',
      },
      {
        'en': 'Galerie Harfa',
        'ru': 'Galerie Harfa',
        'cs': 'Galerie Harfa',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['151', '158', '375'],
      trams: ['8', '25'],
    ),
    coordinates: '50.1063, 14.4927',
    notes: [
      {
        'en': 'Station serves Prague’s major indoor arena and entertainment district.',
        'ru': 'Станция обслуживает главную крытую арену Праги и развлекательный район.',
        'cs': 'Stanice obsluhuje hlavní pražskou multifunkční arénu a zábavní oblast.',
      },
      {
        'en': 'Opened in 1990 during the eastern extension of Line B.',
        'ru': 'Открыта в 1990 году во время восточного продления линии B.',
        'cs': 'Otevřena v roce 1990 během východního prodloužení linky B.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/%C4%8Ceskomoravsk%C3%A1_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
      'https://www.o2arena.cz/en/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'vysocanska': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Vysočany railway station',
          'ru': 'Железнодорожная станция Высочаны',
          'cs': 'Nádraží Vysočany',
        },
        details: {
          'en': 'Exits toward railway station, bus stops, and shopping areas.',
          'ru': 'Выходы к железнодорожной станции, автобусным остановкам и торговым зонам.',
          'cs': 'Výstupy směrem k železniční stanici, autobusovým zastávkám a obchodním oblastem.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Vysočany railway station',
        'ru': 'Станция Высочаны',
        'cs': 'Nádraží Vysočany',
      },
      {
        'en': 'Fénix shopping center',
        'ru': 'Торговый центр Fénix',
        'cs': 'NC Fénix',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['136', '177', '182'],
      trams: ['8', '12', '25'],
      other: [
        {
          'en': 'Railway connection',
          'ru': 'Железнодорожное сообщение',
          'cs': 'Železniční spojení',
        },
      ],
    ),
    coordinates: '50.1105, 14.5019',
    notes: [
      {
        'en': 'Station heavily modernized after flood damage in 2002.',
        'ru': 'Станция была значительно модернизирована после наводнения 2002 года.',
        'cs': 'Stanice byla výrazně modernizována po povodních v roce 2002.',
      },
      {
        'en': 'Important interchange in northeast Prague.',
        'ru': 'Важный пересадочный узел на северо-востоке Праги.',
        'cs': 'Významný přestupní uzel na severovýchodě Prahy.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Vyso%C4%8Dansk%C3%A1_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'kolbenova': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Kolbenova street',
          'ru': 'Улица Колбенова',
          'cs': 'Kolbenova',
        },
        details: {
          'en': 'Main exits toward industrial redevelopment area and business complexes.',
          'ru': 'Главные выходы к району реконструированной промышленной зоны и бизнес-комплексам.',
          'cs': 'Hlavní výstupy směrem k revitalizované průmyslové oblasti a administrativním komplexům.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Pragovka Art District',
        'ru': 'Арт-квартал Pragovka',
        'cs': 'Pragovka',
      },
      {
        'en': 'Kolbenova business area',
        'ru': 'Деловой район Kolbenova',
        'cs': 'Administrativní oblast Kolbenova',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['141', '195'],
      trams: ['12', '19'],
    ),
    coordinates: '50.1103, 14.5148',
    notes: [
      {
        'en': 'Named after engineer Emil Kolben.',
        'ru': 'Названа в честь инженера Эмиля Колбена.',
        'cs': 'Pojmenována po inženýru Emilu Kolbenovi.',
      },
      {
        'en': 'Station area transformed from industrial zone to mixed-use development.',
        'ru': 'Район станции превратился из промышленной зоны в многофункциональную застройку.',
        'cs': 'Oblast stanice se proměnila z průmyslové zóny na multifunkční čtvrť.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Kolbenova_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
      'https://pragovka.com/en/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'hloubetin': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Poděbradská street',
          'ru': 'Улица Подебрадска',
          'cs': 'Poděbradská',
        },
        details: {
          'en': 'Exits toward residential district, tram stops, and local services.',
          'ru': 'Выходы к жилому району, трамвайным остановкам и местным сервисам.',
          'cs': 'Výstupy směrem k obytné čtvrti, tramvajovým zastávkám a místním službám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Hloubětín district',
        'ru': 'Район Глоубетин',
        'cs': 'Hloubětín',
      },
      {
        'en': 'Hloubětín tram depot',
        'ru': 'Трамвайное депо Hloubětín',
        'cs': 'Vozovna Hloubětín',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['110', '141', '171'],
      trams: ['7', '8'],
    ),
    coordinates: '50.1067, 14.5379',
    notes: [
      {
        'en': 'Station reopened in 2022 after complete reconstruction.',
        'ru': 'Станция вновь открыта в 2022 году после полной реконструкции.',
        'cs': 'Stanice byla znovu otevřena v roce 2022 po kompletní rekonstrukci.',
      },
      {
        'en': 'Original station was demolished due to structural issues.',
        'ru': 'Оригинальная станция была снесена из-за конструктивных проблем.',
        'cs': 'Původní stanice byla zbourána kvůli statickým problémům.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Hloub%C4%9Bt%C3%ADn_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en/company/news-and-media/news/detail/317_2446-prague-public-transit-company-opens-the-new-hloubetin-station-on-line-b',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'rajska_zahrada': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Chlumecká street',
          'ru': 'Улица Хлумецка',
          'cs': 'Chlumecká',
        },
        details: {
          'en': 'Exits toward residential areas, bus stops, and nearby railway station.',
          'ru': 'Выходы к жилым районам, автобусным остановкам и ближайшей железнодорожной станции.',
          'cs': 'Výstupy směrem k obytným oblastem, autobusovým zastávkám a blízké železniční stanici.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Rajská zahrada railway station',
        'ru': 'Железнодорожная станция Rajská zahrada',
        'cs': 'Nádraží Rajská zahrada',
      },
      {
        'en': 'Černý Most district',
        'ru': 'Район Черны Мост',
        'cs': 'Černý Most',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['141', '171', '186', '201'],
      other: [
        {
          'en': 'Railway connection',
          'ru': 'Железнодорожное сообщение',
          'cs': 'Železniční spojení',
        },
      ],
    ),
    coordinates: '50.1064, 14.5606',
    notes: [
      {
        'en': 'Opened in 1998 as part of the extension to Černý Most.',
        'ru': 'Открыта в 1998 году как часть продления до Černý Most.',
        'cs': 'Otevřena v roce 1998 jako součást prodloužení do Černého Mostu.',
      },
      {
        'en': 'Known for its unique split-level platform design.',
        'ru': 'Известна своей уникальной двухуровневой конструкцией платформ.',
        'cs': 'Známá svým unikátním dvouúrovňovým uspořádáním nástupišť.',
      },
      {
        'en': 'Received Czech Construction of the Year award in 1999.',
        'ru': 'Получила награду «Строение года Чехии» в 1999 году.',
        'cs': 'Získala ocenění Stavba roku České republiky 1999.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Rajsk%C3%A1_zahrada_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'cerny_most': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Chlumecká street bus terminal',
          'ru': 'Автобусный терминал на улице Хлумецка',
          'cs': 'Autobusový terminál Chlumecká',
        },
        details: {
          'en': 'Main exits toward intercity bus terminal, shopping center, and Park & Ride.',
          'ru': 'Главные выходы к междугороднему автовокзалу, торговому центру и Park & Ride.',
          'cs': 'Hlavní výstupy směrem k meziměstskému autobusovému terminálu, obchodnímu centru a parkovišti P+R.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Centrum Černý Most',
        'ru': 'Торговый центр Centrum Černý Most',
        'cs': 'Centrum Černý Most',
      },
      {
        'en': 'Černý Most bus terminal',
        'ru': 'Автовокзал Černý Most',
        'cs': 'Autobusový terminál Černý Most',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['181', '202', '220', '221', '223', '240'],
      other: [
        {
          'en': 'Intercity bus terminal',
          'ru': 'Междугородний автобусный терминал',
          'cs': 'Meziměstský autobusový terminál',
        },
        {
          'en': 'Park & Ride parking',
          'ru': 'Парковка Park & Ride',
          'cs': 'Parkoviště P+R',
        },
      ],
    ),
    coordinates: '50.1096, 14.5777',
    notes: [
      {
        'en': 'Eastern terminus of Line B since 1998.',
        'ru': 'Восточная конечная линии B с 1998 года.',
        'cs': 'Východní konečná linky B od roku 1998.',
      },
      {
        'en': 'One of the few Prague Metro stations located at ground level.',
        'ru': 'Одна из немногих станций пражского метро, расположенных на уровне земли.',
        'cs': 'Jedna z mála stanic pražského metra umístěných na povrchu.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/%C4%8Cern%C3%BD_Most_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'letnany': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Beranových street',
          'ru': 'Улица Берановых',
          'cs': 'Beranových',
        },
        details: {
          'en': 'North exit toward PVA Expo Prague and Park & Ride.',
          'ru': 'Северный выход к выставочному центру PVA Expo Prague и Park & Ride.',
          'cs': 'Severní výstup směrem k PVA Expo Praha a parkovišti P+R.',
        },
      ),
      StationExit(
        location: {
          'en': 'Bus terminal',
          'ru': 'Автобусный терминал',
          'cs': 'Autobusový terminál',
        },
        details: {
          'en': 'South exit toward major regional and city bus connections.',
          'ru': 'Южный выход к крупным городским и региональным автобусным маршрутам.',
          'cs': 'Jižní výstup směrem k významným městským a regionálním autobusovým linkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'PVA Expo Prague',
        'ru': 'PVA Expo Praha',
        'cs': 'PVA Expo Praha',
      },
      {
        'en': 'Letňany shopping zone',
        'ru': 'Торговая зона Letňany',
        'cs': 'Obchodní zóna Letňany',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['110', '140', '158', '185', '195', '201'],
      other: [
        {
          'en': 'Park & Ride parking',
          'ru': 'Парковка Park & Ride',
          'cs': 'Parkoviště P+R',
        },
      ],
    ),
    coordinates: '50.1257, 14.5150',
    notes: [
      {
        'en': 'Northern terminus of Line C since 2008.',
        'ru': 'Северная конечная линии C с 2008 года.',
        'cs': 'Severní konečná linky C od roku 2008.',
      },
      {
        'en': 'Station opened as part of the extension from Ládví.',
        'ru': 'Станция открыта как часть продления от Ládví.',
        'cs': 'Stanice byla otevřena jako součást prodloužení z Ládví.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Let%C5%88any_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
      'https://www.pvaexpo.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'prosek': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Prosek district',
          'ru': 'Район Просек',
          'cs': 'Prosek',
        },
        details: {
          'en': 'Exits toward residential district and bus interchange.',
          'ru': 'Выходы к жилому району и автобусному узлу.',
          'cs': 'Výstupy směrem k obytné čtvrti a autobusovému přestupu.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Prosek district',
        'ru': 'Район Просек',
        'cs': 'Prosek',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['136', '140', '151', '158', '177', '183'],
    ),
    coordinates: '50.1191, 14.4984',
    notes: [
      {
        'en': 'Opened in 2008 as part of the northern extension of Line C.',
        'ru': 'Открыта в 2008 году как часть северного продления линии C.',
        'cs': 'Otevřena v roce 2008 jako součást severního prodloužení linky C.',
      },
      {
        'en': 'Accessible station with elevators.',
        'ru': 'Станция оборудована лифтами.',
        'cs': 'Stanice je vybavena výtahy.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Prosek_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'strizkov': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Střížkov district',
          'ru': 'Район Стржижков',
          'cs': 'Střížkov',
        },
        details: {
          'en': 'Exits toward residential district and local bus stops.',
          'ru': 'Выходы к жилому району и местным автобусным остановкам.',
          'cs': 'Výstupy směrem k obytné čtvrti a místním autobusovým zastávkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Střížkov district',
        'ru': 'Район Стржижков',
        'cs': 'Střížkov',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['136', '151', '177', '183', '201'],
    ),
    coordinates: '50.1262, 14.4895',
    notes: [
      {
        'en': 'Known for its futuristic glass-and-steel station architecture.',
        'ru': 'Известна своей футуристической архитектурой из стекла и стали.',
        'cs': 'Známá futuristickou architekturou ze skla a oceli.',
      },
      {
        'en': 'Opened in 2008 during the extension toward Letňany.',
        'ru': 'Открыта в 2008 году во время продления к Letňany.',
        'cs': 'Otevřena v roce 2008 během prodloužení do Letňan.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/St%C5%99%C3%AD%C5%BEkov_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'ladvi': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Střelničná street',
          'ru': 'Улица Стржельнична',
          'cs': 'Střelničná',
        },
        details: {
          'en': 'Main exits toward bus terminal, shopping areas, and residential district.',
          'ru': 'Главные выходы к автобусному терминалу, торговым зонам и жилому району.',
          'cs': 'Hlavní výstupy směrem k autobusovému terminálu, obchodním oblastem a obytné čtvrti.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Ládví district',
        'ru': 'Район Ладви',
        'cs': 'Ládví',
      },
      {
        'en': 'Ďáblice area',
        'ru': 'Район Дяблице',
        'cs': 'Ďáblice',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['102', '103', '136', '151', '177', '183'],
      other: [
        {
          'en': 'Major bus terminal',
          'ru': 'Крупный автобусный терминал',
          'cs': 'Významný autobusový terminál',
        },
      ],
    ),
    coordinates: '50.1265, 14.4690',
    notes: [
      {
        'en': 'Northern terminus of Line C from 2004 to 2008.',
        'ru': 'Была северной конечной линии C с 2004 по 2008 год.',
        'cs': 'V letech 2004–2008 byla severní konečnou linky C.',
      },
      {
        'en': 'Opened in 2004 during the extension from Nádraží Holešovice.',
        'ru': 'Открыта в 2004 году во время продления от Nádraží Holešovice.',
        'cs': 'Otevřena v roce 2004 během prodloužení z Nádraží Holešovice.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/L%C3%A1dv%C3%AD_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'kobylisy': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Kobylisy square',
          'ru': 'Площадь Кобылисы',
          'cs': 'Kobyliské náměstí',
        },
        details: {
          'en': 'Exits toward tram stops, bus interchange, and residential district.',
          'ru': 'Выходы к трамвайным остановкам, автобусному узлу и жилому району.',
          'cs': 'Výstupy směrem k tramvajovým zastávkám, autobusovému uzlu a obytné čtvrti.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Kobylisy district',
        'ru': 'Район Кобылисы',
        'cs': 'Kobylisy',
      },
      {
        'en': 'Anthropoid Memorial',
        'ru': 'Мемориал операции Anthropoid',
        'cs': 'Památník operace Anthropoid',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['102', '144', '152', '177', '183'],
      trams: ['1', '10', '14', '17'],
    ),
    coordinates: '50.1237, 14.4526',
    notes: [
      {
        'en': 'Opened in 2004 as part of the northern extension of Line C.',
        'ru': 'Открыта в 2004 году как часть северного продления линии C.',
        'cs': 'Otevřena v roce 2004 jako součást severního prodloužení linky C.',
      },
      {
        'en': 'Station serves a major public transport interchange in northern Prague.',
        'ru': 'Станция обслуживает крупный транспортный узел на севере Праги.',
        'cs': 'Stanice obsluhuje významný dopravní uzel v severní Praze.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Kobylisy_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'nadrazi_holesovice': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Praha-Holešovice railway station',
          'ru': 'Железнодорожный вокзал Прага-Голешовице',
          'cs': 'Nádraží Praha-Holešovice',
        },
        details: {
          'en': 'Direct access to railway station, tram stops, and bus terminal.',
          'ru': 'Прямой доступ к железнодорожному вокзалу, трамвайным остановкам и автобусному терминалу.',
          'cs': 'Přímý přístup k železniční stanici, tramvajovým zastávkám a autobusovému terminálu.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Praha-Holešovice railway station',
        'ru': 'Вокзал Praha-Holešovice',
        'cs': 'Nádraží Praha-Holešovice',
      },
      {
        'en': 'Holešovice district',
        'ru': 'Район Голешовице',
        'cs': 'Holešovice',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['112', '156', '201'],
      trams: ['6', '12', '17'],
      other: [
        {
          'en': 'Railway connection',
          'ru': 'Железнодорожное сообщение',
          'cs': 'Železniční spojení',
        },
      ],
    ),
    coordinates: '50.1102, 14.4400',
    notes: [
      {
        'en': 'Northern terminus of Line C from 1984 to 2004.',
        'ru': 'Была северной конечной линии C с 1984 по 2004 год.',
        'cs': 'V letech 1984–2004 byla severní konečnou linky C.',
      },
      {
        'en': 'Important transfer station between metro and rail services.',
        'ru': 'Важная пересадочная станция между метро и железной дорогой.',
        'cs': 'Významná přestupní stanice mezi metrem a železnicí.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/N%C3%A1dra%C5%BE%C3%AD_Hole%C5%A1ovice_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'vltavska': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Bubenské nábřeží',
          'ru': 'Набережная Bubenské',
          'cs': 'Bubenské nábřeží',
        },
        details: {
          'en': 'Exits toward tram interchange, Vltava riverfront, and Holešovice district.',
          'ru': 'Выходы к трамвайному узлу, набережной Влтавы и району Голешовице.',
          'cs': 'Výstupy směrem k tramvajovému uzlu, nábřeží Vltavy a Holešovicím.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Vltava riverfront',
        'ru': 'Набережная Влтавы',
        'cs': 'Nábřeží Vltavy',
      },
      {
        'en': 'Holešovice Market',
        'ru': 'Пражский рынок Holešovice',
        'cs': 'Holešovická tržnice',
      },
    ],
    nearbyTransport: NearbyTransport(
      trams: ['1', '6', '12', '14', '17', '25'],
    ),
    coordinates: '50.0989, 14.4383',
    notes: [
      {
        'en': 'Station was heavily damaged during the 2002 Prague floods.',
        'ru': 'Станция сильно пострадала во время наводнения 2002 года в Праге.',
        'cs': 'Stanice byla těžce poškozena při povodních v roce 2002.',
      },
      {
        'en': 'Large elevated entrance hall above street level.',
        'ru': 'Большой приподнятый вестибюль над уровнем улицы.',
        'cs': 'Velká vyvýšená odbavovací hala nad úrovní ulice.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Vltavsk%C3%A1_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'florenc_c': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Florenc bus terminal',
          'ru': 'Автовокзал Флоренц',
          'cs': 'Autobusové nádraží Florenc',
        },
        details: {
          'en': 'Exits toward international bus terminal, city center, and transfer corridors to Line B.',
          'ru': 'Выходы к международному автовокзалу, центру города и переходам на линию B.',
          'cs': 'Výstupy směrem k mezinárodnímu autobusovému nádraží, centru města a přestupům na linku B.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Florenc Central Bus Station',
        'ru': 'Центральный автовокзал Флоренц',
        'cs': 'ÚAN Florenc',
      },
      {
        'en': 'Karlín district',
        'ru': 'Район Карлин',
        'cs': 'Karlín',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['133', '135', '175', '207'],
      trams: ['3', '8', '24'],
      other: [
        {
          'en': 'Transfer to Metro Line B',
          'ru': 'Переход на линию метро B',
          'cs': 'Přestup na linku metra B',
        },
        {
          'en': 'International bus terminal',
          'ru': 'Международный автобусный терминал',
          'cs': 'Mezinárodní autobusový terminál',
        },
      ],
    ),
    coordinates: '50.0909, 14.4395',
    notes: [
      {
        'en': 'Interchange station between Lines B and C.',
        'ru': 'Пересадочная станция между линиями B и C.',
        'cs': 'Přestupní stanice mezi linkami B a C.',
      },
      {
        'en': 'One of Prague’s busiest metro stations.',
        'ru': 'Одна из самых загруженных станций метро Праги.',
        'cs': 'Jedna z nejvytíženějších stanic pražského metra.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Florenc_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'hlavni_nadrazi': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Prague Main Railway Station',
          'ru': 'Главный железнодорожный вокзал Праги',
          'cs': 'Praha hlavní nádraží',
        },
        details: {
          'en': 'Direct access to railway station concourse, Airport Express buses, and tram stops.',
          'ru': 'Прямой доступ к железнодорожному вокзалу, автобусам Airport Express и трамвайным остановкам.',
          'cs': 'Přímý přístup do haly hlavního nádraží, na Airport Express a tramvajové zastávky.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Prague Main Railway Station',
        'ru': 'Главный вокзал Праги',
        'cs': 'Praha hlavní nádraží',
      },
      {
        'en': 'Wenceslas Square',
        'ru': 'Вацлавская площадь',
        'cs': 'Václavské náměstí',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['AE'],
      trams: ['5', '9', '15', '26'],
      other: [
        {
          'en': 'Railway connection',
          'ru': 'Железнодорожное сообщение',
          'cs': 'Železniční spojení',
        },
      ],
    ),
    coordinates: '50.0830, 14.4359',
    notes: [
      {
        'en': 'Opened in 1974 as part of the first Prague Metro section.',
        'ru': 'Открыта в 1974 году как часть первого участка пражского метро.',
        'cs': 'Otevřena v roce 1974 jako součást prvního úseku pražského metra.',
      },
      {
        'en': 'Station has side platforms and direct connection to the railway hall.',
        'ru': 'Станция имеет боковые платформы и прямое соединение с вокзалом.',
        'cs': 'Stanice má boční nástupiště a přímé spojení s halou nádraží.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Hlavní_nádraží_(Prague_Metro)',
      'https://www.dpp.cz/cestovani/bezbarierove-cestovani/metro/trasa-c/Hlavni-nadrazi',
      'https://pid.cz/metro/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'ip_pavlova': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'I. P. Pavlova Square',
          'ru': 'Площадь И. П. Павлова',
          'cs': 'Náměstí I. P. Pavlova',
        },
        details: {
          'en': 'Exits toward major tram interchange and Vinohrady district.',
          'ru': 'Выходы к крупному трамвайному узлу и району Винограды.',
          'cs': 'Výstupy směrem k významnému tramvajovému uzlu a Vinohradům.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Vinohrady district',
        'ru': 'Район Винограды',
        'cs': 'Vinohrady',
      },
      {
        'en': 'Charles Square area',
        'ru': 'Район Карловой площади',
        'cs': 'Oblast Karlova náměstí',
      },
    ],
    nearbyTransport: NearbyTransport(
      trams: ['6', '11', '13', '22'],
    ),
    coordinates: '50.0754, 14.4308',
    notes: [
      {
        'en': 'One of the busiest stations in the Prague Metro system.',
        'ru': 'Одна из самых загруженных станций пражского метро.',
        'cs': 'Jedna z nejvytíženějších stanic pražského metra.',
      },
      {
        'en': 'Named after physiologist Ivan Petrovich Pavlov.',
        'ru': 'Названа в честь физиолога Ивана Петровича Павлова.',
        'cs': 'Pojmenována po fyziologovi Ivanu Petroviči Pavlovovi.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/I._P._Pavlova_(Prague_Metro)',
      'https://pid.cz/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'vysehrad': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Nusle Bridge / Vyšehrad',
          'ru': 'Нусельский мост / Вышеград',
          'cs': 'Nuselský most / Vyšehrad',
        },
        details: {
          'en': 'Exits toward Vyšehrad fortress and panoramic city viewpoints.',
          'ru': 'Выходы к крепости Вышеград и панорамным видам на город.',
          'cs': 'Výstupy směrem k Vyšehradu a panoramatickým výhledům na město.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Vyšehrad Fortress',
        'ru': 'Крепость Вышеград',
        'cs': 'Vyšehrad',
      },
      {
        'en': 'Nusle Bridge',
        'ru': 'Нусельский мост',
        'cs': 'Nuselský most',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['134'],
      trams: ['7', '14', '18', '24'],
    ),
    coordinates: '50.0642, 14.4335',
    notes: [
      {
        'en': 'Station is uniquely located on Nusle Bridge with large glass walls.',
        'ru': 'Станция уникально расположена на Нусельском мосту и имеет большие стеклянные стены.',
        'cs': 'Stanice je unikátně umístěna na Nuselském mostě a má velké prosklené stěny.',
      },
      {
        'en': 'Former station name was Gottwaldova until 1990.',
        'ru': 'До 1990 года станция называлась Gottwaldova.',
        'cs': 'Do roku 1990 nesla stanice název Gottwaldova.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Vyšehrad_(Prague_Metro)',
      'https://pid.cz/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'prazskeho_povstani': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Náměstí Hrdinů',
          'ru': 'Площадь Героев',
          'cs': 'Náměstí Hrdinů',
        },
        details: {
          'en': 'Exits toward Nusle district and nearby office buildings.',
          'ru': 'Выходы к району Нусле и ближайшим офисным зданиям.',
          'cs': 'Výstupy směrem do Nuslí a k blízkým kancelářským budovám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Nusle district',
        'ru': 'Район Нусле',
        'cs': 'Nusle',
      },
      {
        'en': 'Congress Centre Prague area',
        'ru': 'Район Конгресс-центра Праги',
        'cs': 'Oblast Kongresového centra Praha',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['134', '188'],
      trams: ['18', '19'],
    ),
    coordinates: '50.0567, 14.4345',
    notes: [
      {
        'en': 'Opened in 1974 with the first section of Line C.',
        'ru': 'Открыта в 1974 году вместе с первым участком линии C.',
        'cs': 'Otevřena v roce 1974 s prvním úsekem linky C.',
      },
      {
        'en': 'Station name refers to the Prague Uprising of 1945.',
        'ru': 'Название станции связано с Пражским восстанием 1945 года.',
        'cs': 'Název stanice odkazuje na Pražské povstání v roce 1945.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Pražského_povstání_(Prague_Metro)',
      'https://pid.cz/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'pankrac': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Arkády Pankrác',
          'ru': 'Arkády Pankrác',
          'cs': 'Arkády Pankrác',
        },
        details: {
          'en': 'Main exits toward shopping center, office district, and tram stops.',
          'ru': 'Главные выходы к торговому центру, офисному району и трамвайным остановкам.',
          'cs': 'Hlavní výstupy směrem k obchodnímu centru, kancelářské čtvrti a tramvajovým zastávkám.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Arkády Pankrác',
        'ru': 'Arkády Pankrác',
        'cs': 'Arkády Pankrác',
      },
      {
        'en': 'Pankrác business district',
        'ru': 'Деловой район Панкрац',
        'cs': 'Administrativní oblast Pankrác',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['118', '134', '188', '193'],
      trams: ['18', '19'],
      other: [
        {
          'en': 'Future transfer to Metro Line D',
          'ru': 'Будущий переход на линию метро D',
          'cs': 'Budoucí přestup na linku metra D',
        },
      ],
    ),
    coordinates: '50.0518, 14.4399',
    notes: [
      {
        'en': 'Opened in 1974 with the first section of Prague Metro.',
        'ru': 'Открыта в 1974 году вместе с первым участком пражского метро.',
        'cs': 'Otevřena v roce 1974 s prvním úsekem pražského metra.',
      },
      {
        'en': 'Station was closed during 2025 for major reconstruction related to Metro Line D.',
        'ru': 'Станция была закрыта в 2025 году на реконструкцию, связанную с линией метро D.',
        'cs': 'Stanice byla v roce 2025 uzavřena kvůli rekonstrukci související s linkou D.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Pankr%C3%A1c_(Prague_Metro)',
      'https://www.dpp.cz/metro-d/stanice/stanice-pankrac',
      'https://pid.cz/en/metro/',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'budejovicka': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Budějovická square',
          'ru': 'Площадь Будейовицка',
          'cs': 'Budějovické náměstí',
        },
        details: {
          'en': 'Exits toward office complexes, shopping center, and bus terminal.',
          'ru': 'Выходы к офисным комплексам, торговому центру и автобусному терминалу.',
          'cs': 'Výstupy směrem k administrativním budovám, obchodnímu centru a autobusovému terminálu.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'DBK Shopping Center',
        'ru': 'Торговый центр DBK',
        'cs': 'DBK',
      },
      {
        'en': 'Brumlovka office district',
        'ru': 'Офисный район Brumlovka',
        'cs': 'Administrativní oblast Brumlovka',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['106', '118', '121', '124', '134', '170'],
    ),
    coordinates: '50.0445, 14.4485',
    notes: [
      {
        'en': 'Opened in 1974 with the original Line C section.',
        'ru': 'Открыта в 1974 году вместе с первоначальным участком линии C.',
        'cs': 'Otevřena v roce 1974 s původním úsekem linky C.',
      },
      {
        'en': 'Major transport hub in Prague 4.',
        'ru': 'Крупный транспортный узел в Праге 4.',
        'cs': 'Významný dopravní uzel v Praze 4.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Bud%C4%9Bjovick%C3%A1_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'kacerov': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Kačerov bus terminal',
          'ru': 'Автобусный терминал Kačerov',
          'cs': 'Autobusový terminál Kačerov',
        },
        details: {
          'en': 'Direct access to bus terminal and nearby office area.',
          'ru': 'Прямой доступ к автобусному терминалу и офисному району.',
          'cs': 'Přímý přístup k autobusovému terminálu a kancelářské oblasti.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Kačerov bus terminal',
        'ru': 'Автовокзал Kačerov',
        'cs': 'Autobusové nádraží Kačerov',
      },
      {
        'en': 'Michelský les',
        'ru': 'Михельский лес',
        'cs': 'Michelský les',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['113', '115', '193', '215', '331', '333'],
      other: [
        {
          'en': 'Major suburban bus interchange',
          'ru': 'Крупный пригородный автобусный узел',
          'cs': 'Významný příměstský autobusový uzel',
        },
      ],
    ),
    coordinates: '50.0419, 14.4597',
    notes: [
      {
        'en': 'Southern terminus of Line C from 1974 to 1980.',
        'ru': 'Была южной конечной линии C с 1974 по 1980 год.',
        'cs': 'V letech 1974–1980 byla jižní konečnou linky C.',
      },
      {
        'en': 'Connected to historic metro depot facilities.',
        'ru': 'Связана с историческим депо метро.',
        'cs': 'Napojena na historické depo metra.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Ka%C4%8Derov_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'roztyly': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Roztyly bus station',
          'ru': 'Автостанция Roztyly',
          'cs': 'Autobusové nádraží Roztyly',
        },
        details: {
          'en': 'Exits toward intercity bus terminal and Kunratice Forest.',
          'ru': 'Выходы к междугороднему автовокзалу и Кунратицкому лесу.',
          'cs': 'Výstupy směrem k meziměstskému autobusovému terminálu a Kunratickému lesu.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Kunratice Forest',
        'ru': 'Кунратицкий лес',
        'cs': 'Kunratický les',
      },
      {
        'en': 'Roztyly district',
        'ru': 'Район Roztyly',
        'cs': 'Roztyly',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['135', '177', '203', '385'],
      other: [
        {
          'en': 'Intercity bus terminal',
          'ru': 'Междугородний автобусный терминал',
          'cs': 'Meziměstský autobusový terminál',
        },
      ],
    ),
    coordinates: '50.0374, 14.4786',
    notes: [
      {
        'en': 'Opened in 1980 during extension from Kačerov to Háje.',
        'ru': 'Открыта в 1980 году при продлении от Kačerov до Háje.',
        'cs': 'Otevřena v roce 1980 při prodloužení z Kačerova do Hájů.',
      },
      {
        'en': 'Former station name was Primátora Vacka.',
        'ru': 'Прежнее название станции — Primátora Vacka.',
        'cs': 'Původní název stanice byl Primátora Vacka.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Roztyly_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'chodov': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Westfield Chodov',
          'ru': 'Westfield Chodov',
          'cs': 'Westfield Chodov',
        },
        details: {
          'en': 'Direct access toward shopping center and surrounding office district.',
          'ru': 'Прямой доступ к торговому центру и окружающему офисному району.',
          'cs': 'Přímý přístup k obchodnímu centru a okolní kancelářské čtvrti.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Westfield Chodov',
        'ru': 'Westfield Chodov',
        'cs': 'Westfield Chodov',
      },
      {
        'en': 'Chodov district',
        'ru': 'Район Chodov',
        'cs': 'Chodov',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['115', '125', '126', '154', '177', '197'],
    ),
    coordinates: '50.0310, 14.4907',
    notes: [
      {
        'en': 'Opened in 1980 as part of the extension toward Háje.',
        'ru': 'Открыта в 1980 году как часть продления к Háje.',
        'cs': 'Otevřena v roce 1980 jako součást prodloužení do Hájů.',
      },
      {
        'en': 'One of the busiest shopping-oriented stations in Prague.',
        'ru': 'Одна из самых загруженных торговых станций Праги.',
        'cs': 'Jedna z nejvytíženějších nákupních stanic v Praze.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Chodov_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.westfield.com/czech-republic/chodov',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'opatov': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Opatov bus terminal',
          'ru': 'Автобусный терминал Opatov',
          'cs': 'Autobusový terminál Opatov',
        },
        details: {
          'en': 'Main exits toward regional bus terminal, office buildings, and residential district.',
          'ru': 'Главные выходы к региональному автобусному терминалу, офисным зданиям и жилому району.',
          'cs': 'Hlavní výstupy směrem k regionálnímu autobusovému terminálu, administrativním budovám a obytné čtvrti.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Opatov office district',
        'ru': 'Офисный район Opatov',
        'cs': 'Administrativní oblast Opatov',
      },
      {
        'en': 'Jižní Město',
        'ru': 'Южный город',
        'cs': 'Jižní Město',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['125', '136', '165', '177', '213', '326', '385'],
      other: [
        {
          'en': 'Regional bus terminal',
          'ru': 'Региональный автобусный терминал',
          'cs': 'Regionální autobusový terminál',
        },
      ],
    ),
    coordinates: '50.0281, 14.5075',
    notes: [
      {
        'en': 'Opened in 1980 during the extension from Kačerov to Háje.',
        'ru': 'Открыта в 1980 году при продлении от Kačerov до Háje.',
        'cs': 'Otevřena v roce 1980 při prodloužení z Kačerova do Hájů.',
      },
      {
        'en': 'Station serves the Jižní Město residential development.',
        'ru': 'Станция обслуживает жилой район Jižní Město.',
        'cs': 'Stanice obsluhuje sídliště Jižní Město.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/Opatov_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
  'haje': StationDetail(
    exits: [
      StationExit(
        location: {
          'en': 'Háje bus terminal',
          'ru': 'Автобусный терминал Háje',
          'cs': 'Autobusový terminál Háje',
        },
        details: {
          'en': 'Main exits toward bus terminal, residential district, and shopping facilities.',
          'ru': 'Главные выходы к автобусному терминалу, жилому району и торговым объектам.',
          'cs': 'Hlavní výstupy směrem k autobusovému terminálu, obytné čtvrti a obchodům.',
        },
      ),
    ],
    nearbyPlaces: [
      {
        'en': 'Jižní Město',
        'ru': 'Южный город',
        'cs': 'Jižní Město',
      },
      {
        'en': 'Háje district',
        'ru': 'Район Háje',
        'cs': 'Háje',
      },
    ],
    nearbyTransport: NearbyTransport(
      buses: ['125', '165', '170', '203', '240', '385'],
      other: [
        {
          'en': 'Major suburban bus interchange',
          'ru': 'Крупный пригородный автобусный узел',
          'cs': 'Významný příměstský autobusový uzel',
        },
      ],
    ),
    coordinates: '50.0305, 14.5260',
    notes: [
      {
        'en': 'Southern terminus of Line C since 1980.',
        'ru': 'Южная конечная линии C с 1980 года.',
        'cs': 'Jižní konečná linky C od roku 1980.',
      },
      {
        'en': 'Former station name was Kosmonautů until 1990.',
        'ru': 'До 1990 года станция называлась Kosmonautů.',
        'cs': 'Do roku 1990 nesla stanice název Kosmonautů.',
      },
      {
        'en': 'Station features one of the largest above-ground vestibules in the network.',
        'ru': 'Станция имеет один из крупнейших надземных вестибюлей в сети метро.',
        'cs': 'Stanice má jednu z největších nadzemních vestibulů v síti metra.',
      },
    ],
    sources: [
      'https://en.wikipedia.org/wiki/H%C3%A1je_(Prague_Metro)',
      'https://pid.cz/en/metro/',
      'https://www.dpp.cz/en',
    ],
    verifiedDate: '2026-05-16',
    confidence: {
      'en': 'high',
      'ru': 'high',
      'cs': 'high',
    },
  ),
};

const StationDetail _mustekDetails = StationDetail(
  exits: [
    StationExit(
      location: {
        'en': 'Lower Wenceslas Square',
        'ru': 'Нижняя часть Вацлавской площади',
        'cs': 'Dolní část Václavského náměstí',
      },
      details: {
        'en': 'Exit toward shopping areas, Old Town, and Line B transfer corridors.',
        'ru': 'Выход к торговым районам, Старому городу и переходам на линию B.',
        'cs': 'Výstup směrem k obchodním oblastem, Starému Městu a přestupům na linku B.',
      },
    ),
    StationExit(
      location: {
        'en': 'Na Můstku',
        'ru': 'На Мустку',
        'cs': 'Na Můstku',
      },
      details: {
        'en': 'Historic city-center entrance near pedestrian zone.',
        'ru': 'Исторический вход в центре города рядом с пешеходной зоной.',
        'cs': 'Historický vstup v centru města poblíž pěší zóny.',
      },
    ),
  ],
  nearbyPlaces: [
    {
      'en': 'Wenceslas Square',
      'ru': 'Вацлавская площадь',
      'cs': 'Václavské náměstí',
    },
    {
      'en': 'Old Town',
      'ru': 'Старый город',
      'cs': 'Staré Město',
    },
    {
      'en': 'Shopping district',
      'ru': 'Торговый район',
      'cs': 'Obchodní čtvrť',
    },
  ],
  nearbyTransport: NearbyTransport(
    other: [
      {
        'en': 'Transfer to Metro Line B',
        'ru': 'Переход на линию метро B',
        'cs': 'Přestup na linku metra B',
      },
    ],
  ),
  coordinates: '50.0846, 14.4235',
  notes: [
    {
      'en': 'Major transfer station between Metro Lines A and B.',
      'ru': 'Крупная пересадочная станция между линиями A и B.',
      'cs': 'Významná přestupní stanice mezi linkami A a B.',
    },
    {
      'en': 'Station name refers to a medieval bridge discovered during construction.',
      'ru': 'Название станции связано со средневековым мостом, найденным при строительстве.',
      'cs': 'Název stanice odkazuje na středověký most objevený během výstavby.',
    },
    {
      'en': 'Preserved remains of the medieval bridge can be viewed inside the station.',
      'ru': 'Сохранившиеся остатки средневекового моста можно увидеть внутри станции.',
      'cs': 'Dochované pozůstatky středověkého mostu jsou viditelné uvnitř stanice.',
    },
  ],
  sources: [
    'https://www.dpp.cz/en',
    'https://pid.cz/en/metro/',
    'https://prague.eu/en/public-transport/',
    'https://www.myczechrepublic.com/prague/prague-transportation-system/prague-metro-subway/',
    'https://www.metrolinemap.com/station/prague/mustek/',
    'https://en.wikipedia.org/wiki/Prague_Metro',
    'https://www.atlasobscura.com/places/mustek-bridge',
  ],
  verifiedDate: '2026-05-16',
  confidence: {
    'en': 'high',
    'ru': 'high',
    'cs': 'high',
  },
);

const StationDetail _mustekBDetails = StationDetail(
  exits: [
    StationExit(
      location: {
        'en': 'Lower Wenceslas Square',
        'ru': 'Нижняя часть Вацлавской площади',
        'cs': 'Dolní část Václavského náměstí',
      },
      details: {
        'en': 'Main exits toward shopping areas, Old Town, and transfer corridors to Line A.',
        'ru': 'Главные выходы к торговым районам, Старому городу и переходам на линию A.',
        'cs': 'Hlavní výstupy směrem k obchodním oblastem, Starému Městu a přestupům na linku A.',
      },
    ),
  ],
  nearbyPlaces: [
    {
      'en': 'Wenceslas Square',
      'ru': 'Вацлавская площадь',
      'cs': 'Václavské náměstí',
    },
    {
      'en': 'Old Town',
      'ru': 'Старый город',
      'cs': 'Staré Město',
    },
  ],
  nearbyTransport: NearbyTransport(
    trams: ['3', '5', '6', '9', '14', '24'],
    other: [
      {
        'en': 'Transfer to Metro Line A',
        'ru': 'Переход на линию метро A',
        'cs': 'Přestup na linku metra A',
      },
    ],
  ),
  coordinates: '50.0846, 14.4235',
  notes: [
    {
      'en': 'Major interchange station between Lines A and B.',
      'ru': 'Крупная пересадочная станция между линиями A и B.',
      'cs': 'Významná přestupní stanice mezi linkami A a B.',
    },
    {
      'en': 'Named after a medieval bridge discovered during station construction.',
      'ru': 'Название связано со средневековым мостом, найденным при строительстве станции.',
      'cs': 'Název odkazuje na středověký most objevený během výstavby stanice.',
    },
  ],
  sources: [
    'https://en.wikipedia.org/wiki/M%C5%AFstek_(Prague_Metro)',
    'https://pid.cz/en/metro/',
    'https://www.dpp.cz/en',
  ],
  verifiedDate: '2026-05-16',
  confidence: {
    'en': 'high',
    'ru': 'high',
    'cs': 'high',
  },
);

const StationDetail _muzeumDetails = StationDetail(
  exits: [
    StationExit(
      location: {
        'en': 'National Museum / Upper Wenceslas Square',
        'ru': 'Национальный музей / верхняя часть Вацлавской площади',
        'cs': 'Národní muzeum / horní část Václavského náměstí',
      },
      details: {
        'en': 'Main exit toward the National Museum and Wenceslas Square.',
        'ru': 'Главный выход к Национальному музею и Вацлавской площади.',
        'cs': 'Hlavní výstup směrem k Národnímu muzeu a Václavskému náměstí.',
      },
    ),
    StationExit(
      location: {
        'en': 'Transfer corridor to Line C',
        'ru': 'Переход на линию C',
        'cs': 'Přestupní chodba na linku C',
      },
      details: {
        'en': 'Underground transfer between Lines A and C.',
        'ru': 'Подземный переход между линиями A и C.',
        'cs': 'Podzemní přestup mezi linkami A a C.',
      },
    ),
  ],
  nearbyPlaces: [
    {
      'en': 'National Museum',
      'ru': 'Национальный музей',
      'cs': 'Národní muzeum',
    },
    {
      'en': 'Wenceslas Square',
      'ru': 'Вацлавская площадь',
      'cs': 'Václavské náměstí',
    },
    {
      'en': 'New Town',
      'ru': 'Новый город',
      'cs': 'Nové Město',
    },
  ],
  nearbyTransport: NearbyTransport(
    other: [
      {
        'en': 'Transfer to Metro Line C',
        'ru': 'Переход на линию метро C',
        'cs': 'Přestup na linku metra C',
      },
    ],
  ),
  coordinates: '50.0799, 14.4301',
  notes: [
    {
      'en': 'Major interchange station between Lines A and C.',
      'ru': 'Крупная пересадочная станция между линиями A и C.',
      'cs': 'Významná přestupní stanice mezi linkami A a C.',
    },
    {
      'en': 'Located beneath Wenceslas Square near the National Museum.',
      'ru': 'Расположена под Вацлавской площадью рядом с Национальным музеем.',
      'cs': 'Nachází se pod Václavským náměstím poblíž Národního muzea.',
    },
    {
      'en': 'Barrier-free access available via elevators.',
      'ru': 'Доступна безбарьерная среда с лифтами.',
      'cs': 'Bezbariérový přístup pomocí výtahů.',
    },
  ],
  sources: [
    'https://www.dpp.cz/en',
    'https://pid.cz/en/metro/',
    'https://en.wikipedia.org/wiki/Muzeum_(Prague_Metro)',
    'https://metro.angrenost.cz/a/mu.php',
    'https://prague.eu/en/public-transport/',
  ],
  verifiedDate: '2026-05-16',
  confidence: {
    'en': 'high',
    'ru': 'high',
    'cs': 'high',
  },
);

const StationDetail _muzeumCDetails = StationDetail(
  exits: [
    StationExit(
      location: {
        'en': 'National Museum / Wenceslas Square',
        'ru': 'Национальный музей / Вацлавская площадь',
        'cs': 'Národní muzeum / Václavské náměstí',
      },
      details: {
        'en': 'Main exits toward the National Museum and transfer corridors to Line A.',
        'ru': 'Главные выходы к Национальному музею и переходам на линию A.',
        'cs': 'Hlavní výstupy směrem k Národnímu muzeu a přestupům na linku A.',
      },
    ),
  ],
  nearbyPlaces: [
    {
      'en': 'National Museum',
      'ru': 'Национальный музей',
      'cs': 'Národní muzeum',
    },
    {
      'en': 'Wenceslas Square',
      'ru': 'Вацлавская площадь',
      'cs': 'Václavské náměstí',
    },
  ],
  nearbyTransport: NearbyTransport(
    trams: ['11', '13', '22'],
    other: [
      {
        'en': 'Transfer to Metro Line A',
        'ru': 'Переход на линию метро A',
        'cs': 'Přestup na linku metra A',
      },
    ],
  ),
  coordinates: '50.0799, 14.4301',
  notes: [
    {
      'en': 'Major interchange station between Lines A and C.',
      'ru': 'Крупная пересадочная станция между линиями A и C.',
      'cs': 'Významná přestupní stanice mezi linkami A a C.',
    },
    {
      'en': 'Line C section opened on 9 May 1974.',
      'ru': 'Часть линии C открыта 9 мая 1974 года.',
      'cs': 'Část linky C byla otevřena 9. května 1974.',
    },
  ],
  sources: [
    'https://en.wikipedia.org/wiki/Muzeum_(Prague_Metro)',
    'https://mapy.com/en/?id=15305991&source=pubt',
    'https://pid.cz/metro/',
  ],
  verifiedDate: '2026-05-16',
  confidence: {
    'en': 'high',
    'ru': 'high',
    'cs': 'high',
  },
);

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
