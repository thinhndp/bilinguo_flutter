import 'models/Course.dart';
import 'models/CourseGroup.dart';

Course coBan1 = new Course(
  '0',
  'Cơ bản 1',
  'unlocked-exercise-icons/co-ban-1.png',
  'locked-exercise-icons/co-ban-1.png',
  '#78C800',
  2,
  true,
  0.6,
);

Course coBan2 = new Course(
  '1',
  'Cơ bản 2',
  'unlocked-exercise-icons/co-ban-2.png',
  'locked-exercise-icons/co-ban-2.png',
  '#1CB0F6',
  1,
  true,
  0.25,
);

Course cumTu = new Course(
  '2',
  'Cụm từ',
  'unlocked-exercise-icons/cum-tu.png',
  'locked-exercise-icons/cum-tu.png',
  '#1CB0F6',
  1,
  true,
  0.8,
);

Course monAn = new Course(
  '3',
  'Món ăn',
  'unlocked-exercise-icons/mon-an.png',
  'locked-exercise-icons/mon-an.png',
  '#ce82ff',
  0,
  true,
  0.5,
);

Course dongVat = new Course(
  '4',
  'Động vật',
  'unlocked-exercise-icons/dong-vat.png',
  'locked-exercise-icons/dong-vat.png',
  '#ce82ff',
  0,
  true,
  0.0,
);

Course soNhieu = new Course(
  '5',
  'Số Nhiều',
  'unlocked-exercise-icons/so-nhieu.png',
  'locked-exercise-icons/so-nhieu.png',
  '#1CB0F6',
  0,
  true,
  0.0,
);

Course soHuu = new Course(
  '6',
  'Sở Hữu',
  'unlocked-exercise-icons/so-huu.png',
  'locked-exercise-icons/so-huu.png',
  '#1CB0F6',
  0,
  true,
  0.0,
);

Course daiTuKhachQuan = new Course(
  '7',
  'Đại từ',
  'unlocked-exercise-icons/dai-tu-khach-quan.png',
  'locked-exercise-icons/dai-tu-khach-quan.png',
  '#ce82ff',
  0,
  true,
  0.0,
);

Course quanAo = new Course(
  '8',
  'Quần Áo',
  'unlocked-exercise-icons/quan-ao.png',
  'locked-exercise-icons/quan-ao.png',
  '#1CB0F6',
  0,
  true,
  0.0,
);

Course dongTu = new Course(
  '9',
  'Động từ',
  'unlocked-exercise-icons/dong-tu.png',
  'locked-exercise-icons/dong-tu.png',
  '#ce82ff',
  0,
  true,
  0.0,
);

Course mauSac = new Course(
  '10',
  'Màu Sắc',
  'unlocked-exercise-icons/mau-sac.png',
  'locked-exercise-icons/mau-sac.png',
  '#ce82ff',
  0,
  true,
  0.0,
);

Course cauHoi = new Course(
  '11',
  'Câu Hỏi',
  'unlocked-exercise-icons/cau-hoi.png',
  'locked-exercise-icons/cau-hoi.png',
  '#1CB0F6',
  0,
  false,
  0.0,
);

Course lienTu = new Course(
  '12',
  'Liên Từ',
  'unlocked-exercise-icons/lien-tu.png',
  'locked-exercise-icons/lien-tu.png',
  '#1CB0F6',
  0,
  false,
  0.0,
);

Course gioiTu = new Course(
  '13',
  'Giới Từ',
  'unlocked-exercise-icons/gioi-tu.png',
  'locked-exercise-icons/gioi-tu.png',
  '#1CB0F6',
  0,
  false,
  0.0,
);

Course thoiGian = new Course(
  '14',
  'Thời Gian',
  'unlocked-exercise-icons/thoi-gian.png',
  'locked-exercise-icons/thoi-gian.png',
  '#1CB0F6',
  0,
  false,
  0.0,
);

Course giaDinh = new Course(
  '15',
  'Gia Đình',
  'unlocked-exercise-icons/gia-dinh.png',
  'locked-exercise-icons/gia-dinh.png',
  '#1CB0F6',
  0,
  false,
  0.0,
);

CourseGroup courseGroup1 = new CourseGroup(
    0,
    [
      [ coBan1 ],
      [ coBan2, cumTu ],
      [ monAn, dongVat, daiTuKhachQuan ],
      [ soNhieu, soHuu ],
      [ soHuu, cumTu ]
    ]
);

CourseGroup courseGroup2 = new CourseGroup(
    1,
    [
      [ quanAo ],
      [ dongTu, mauSac ],
      [ cauHoi, lienTu ],
      [ gioiTu ],
      [ thoiGian, giaDinh ],
    ]
);