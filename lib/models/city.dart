class City {
  final String id;
  final String name;
  final String arabicName;
  final String description;
  final String history;
  final List<String> landmarks;
  final List<String> images;
  final double latitude;
  final double longitude;
  final bool isFavorite;

  City({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.description,
    required this.history,
    required this.landmarks,
    required this.images,
    required this.latitude,
    required this.longitude,
    this.isFavorite = false,
  });

  City copyWith({
    String? id,
    String? name,
    String? arabicName,
    String? description,
    String? history,
    List<String>? landmarks,
    List<String>? images,
    double? latitude,
    double? longitude,
    bool? isFavorite,
  }) {
    return City(
      id: id ?? this.id,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      description: description ?? this.description,
      history: history ?? this.history,
      landmarks: landmarks ?? this.landmarks,
      images: images ?? this.images,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class CitiesData {
  static List<City> cities = [
    City(
      id: 'jerusalem',
      name: 'Jerusalem',
      arabicName: 'القُدس',
      description:
          'Jerusalem is a city in Western Asia, on a plateau in the Judaean Mountains between the Mediterranean and the Dead Sea. It is one of the oldest cities in the world, and is considered holy to the three major Abrahamic religions—Judaism, Christianity, and Islam.',
      history:
          'Jerusalem has been destroyed at least twice, besieged 23 times, captured and recaptured 44 times, and attacked 52 times. The part of Jerusalem called the City of David shows first signs of settlement in the 4th millennium BCE, in the shape of encampments of nomadic shepherds.',
      landmarks: [
        'Al-Aqsa Mosque',
        'Dome of the Rock',
        'Western Wall',
        'Church of the Holy Sepulchre',
        'Old City',
      ],
      images: [
        'assets/images/Jersusalem1.jpg',
        'assets/images/jerusalem2.jpg',
        'assets/images/jerusalem3.jpeg',
      ],
      latitude: 31.7683,
      longitude: 35.2137,
    ),
    City(
      id: 'bethlehem',
      name: 'Bethlehem',
      arabicName: 'بيت لحم',
      description:
          'Bethlehem is a city located in the central West Bank, Palestine, about 10 km south of Jerusalem. It is the capital of the Bethlehem Governorate. The economy is primarily tourist-driven, peaking during the Christmas season.',
      history:
          'The earliest reference to Bethlehem appears in the Amarna Letters (c. 1400 BCE). The New Testament identifies Bethlehem as the birthplace of Jesus. The town was destroyed by the Emperor Hadrian during the Second Jewish Revolt, and rebuilt by Constantine and Helen in the 4th century.',
      landmarks: [
        'Church of the Nativity',
        'Manger Square',
        'Milk Grotto',
        'Shepherd\'s Field',
        'Solomon\'s Pools',
      ],
      images: [
        'assets/images/Bethlehem1.jpg',
        'assets/images/Bethlehem2.jpg',
        'assets/images/Bethlehem3.jpg',
      ],
      latitude: 31.7054,
      longitude: 35.2024,
    ),
    City(
      id: 'gaza',
      name: 'Gaza',
      arabicName: 'غزة',
      description:
          'Gaza City is a Palestinian city in the Gaza Strip. It is the largest city in the State of Palestine and the Gaza Strip, and is located on the Mediterranean coast. Despite ongoing challenges, Gaza has a rich cultural heritage and is known for its resilient people.',
      history:
          'Gaza has a rich history dating back to ancient times. It was mentioned in Egyptian records from the 15th century BCE. Throughout its history, Gaza has been ruled by various empires including the Egyptians, Assyrians, Babylonians, Persians, Greeks, Romans, Byzantines, Arabs, Crusaders, Mamluks, and Ottomans.',
      landmarks: [
        'Great Mosque of Gaza',
        'Al-Omari Mosque',
        'Gaza Old Port',
        'Qasr al-Basha',
        'Ancient Antonia',
      ],
      images: [
        'assets/images/gaza1.jpeg',
        'assets/images/gaza2.jpeg',
        'assets/images/gaza3.jpeg',
      ],
      latitude: 31.5204,
      longitude: 34.4667,
    ),
    City(
      id: 'nablus',
      name: 'Nablus',
      arabicName: 'نابلس',
      description:
          'Nablus is a city in the northern West Bank, Palestine, approximately 49 kilometers north of Jerusalem. It is the capital of the Nablus Governorate and a Palestinian commercial and cultural center. The city is known for its famous knafeh sweet dessert and its olive oil soap production.',
      history:
          'Nablus was founded by the Roman Emperor Vespasian in 72 CE as Flavia Neapolis. The ancient city of Shechem was located nearby. Nablus has a rich and diverse history, having been ruled by the Romans, Byzantines, Crusaders, Mamluks, and Ottomans. It became a center for Palestinian nationalism during the 20th century.',
      landmarks: [
        'Old City of Nablus',
        'Jacob\'s Well',
        'Joseph\'s Tomb',
        'Al-Kabir Mosque',
        'Soap Factories',
      ],
      images: [
        'assets/images/nablus1.jpg',
        'assets/images/nablus2.jpeg',
        'assets/images/nablus3.jpeg',
      ],
      latitude: 32.2222,
      longitude: 35.2625,
    ),
    City(
      id: 'hebron',
      name: 'Hebron',
      arabicName: 'الخليل',
      description:
          'Hebron is a Palestinian city located in the southern West Bank, Palestine, 30 km south of Jerusalem. It is the largest city in the West Bank and the second largest in the Palestinian territories after Gaza City. The city is divided into Palestinian and Israeli zones.',
      history:
          'Hebron is one of the oldest cities in the region and is mentioned in the Bible as the place where Abraham settled. It was conquered by the Canaanites, Israelites, Romans, Byzantines, Muslim Arabs, Crusaders, Mamluks, and the Ottoman Empire. The city is home to the Cave of the Patriarchs, a sacred site for Muslims and Jews.',
      landmarks: [
        'Cave of the Patriarchs',
        'Old City of Hebron',
        'Abraham\'s Oak',
        'Glass and Ceramic Factories',
        'Ibrahimi Mosque',
      ],
      images: [
        'assets/images/hebron1.jpeg',
        'assets/images/hebron2.jpeg',
        'assets/images/hebron3.jpeg',
      ],
      latitude: 31.5326,
      longitude: 35.0998,
    ),
    City(
      id: 'jericho',
      name: 'Jericho',
      arabicName: 'أريحا',
      description:
          'Jericho is a Palestinian city located near the Jordan River in the West Bank. It is believed to be one of the oldest inhabited cities in the world and is known for its natural beauty and historical significance. The city lies 258 meters below sea level, making it the lowest permanently inhabited site on Earth.',
      history:
          'Archaeological evidence indicates Jericho is one of the oldest continuously inhabited cities in the world, with evidence of settlement dating back to 9,000 BCE. The city has been destroyed and rebuilt many times throughout its long history. It is mentioned numerous times in the Bible, notably for the story of Joshua and the Battle of Jericho.',
      landmarks: [
        'Tell es-Sultan (Ancient Jericho)',
        'Hisham\'s Palace',
        'Mount of Temptation',
        'Zacchaeus\' Tree',
        'Jericho Cable Car',
      ],
      images: [
        'assets/images/jercho1.webp',
        'assets/images/jercho2.webp',
        'assets/images/jercho3.jpg',
      ],
      latitude: 31.8667,
      longitude: 35.4500,
    ),
  ];
}