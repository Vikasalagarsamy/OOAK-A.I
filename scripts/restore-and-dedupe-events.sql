-- Start transaction
BEGIN;

-- Insert initial events
INSERT INTO events (event_id, name, is_active)
VALUES 
('E9WH5ETQA', 'Pre Engagement', true),
('ETWBERHT4', 'Odugu', true),
('ESRLX4ZT9', 'Ad Shoot', true),
('E3VUGZL4N', 'Traditional Event', true),
('E6EWXGJLK', 'Sathyanarayana Pooja (Groom side)', true),
('E5GVGVHA9', 'Uruthi Varthai', true),
('EXZU2WY2C', 'Outdoor Shoot', true),
('EK695Y8PR', 'Pellikuthuru/Mangalasnanam', true),
('EVJ76GQHM', 'Groom''s Roce', true),
('EASKPK4F8', 'Haldi & Pellikodukku', true),
('ELXFRWZNM', 'Birthday', true),
('E7L89S5UD', 'Wedding Anniversary', true),
('EK2MGHL53', 'Nichayathartham', true),
('EV6TKZXAN', 'Sami Valipadu', true),
('EA4HM3BNR', 'Nichayathartham & Reception', true),
('EE9CZC9SQ', 'Pellikodukku', true),
('ESXGCQAQ3', 'Get together', true),
('E7VZEV8T7', 'Engagement & Seeru', true),
('E29WEWJ3W', 'Batisi', true),
('ED74PE2HS', 'Pre-Wedding Reception', true),
('EZ996CUX6', 'Bride Pandhakaal', true),
('EFDW6EU5J', 'Bride''s Roce', true),
('E4Q69SZBC', 'Pre Wedding Function (Groom)', true),
('EG3UX7C9K', 'Pasupu or Pasupu Kottadam', true),
('EQ4BJMJA8', 'Brahmin Wedding (Telugu)', true),
('ESWNN7388', '60th Birthday', true),
('E6RJQ386P', 'Mottai & Kathukuthu', true),
('ECUHNDNR9', 'Welcoming Event', true),
('ELWUFJ4JF', 'Bharaat', true),
('EWQC8V2C7', 'Groom Entry', true),
('ENWAC437X', 'Vilayadal', true),
('E5SCF6KDS', 'Muhurtham', true),
('E8TYW2S24', 'Virunthu', true),
('ENA3GXVN8', 'Pandhakal & Nalangu', true),
('EJA4KYF7X', 'Ear Piercing', true),
('EF39TW8NM', 'Mapillai Azhaippu', true),
('ESXGSMK85', 'Pandhakaal, Pellikodukku, Pellikuthuru', true),
('E9UXMMDHG', 'Baby Event', true),
('E9NVD5XN5', 'Decor Coverage', true),
('ENDY5TY9B', 'Commercial shoot', true),
('ENECQUZ6U', 'Hindu Wedding', true),
('E44R25GHH', 'Branding Shoot', true),
('EQS67AH2T', 'Baby Shoot Indoor', true),
('ESUYUY8QJ', 'Sauntiya Habba', true),
('EJKVYRAM8', 'Sumangali Pooja', true),
('ECHE4SHJT', 'Traditional Event 2', true),
('EHV3DAH9D', 'Outdoor Videoshoot', true),
('EPYC7ZW6S', 'Engagement/Sangeet', true),
('EC9VQVU3J', 'Mehandi', true),
('EJH342598', 'Christian Wedding', true),
('EHQSGBZJF', 'Corporate Shoot', true),
('EB29D4F2J', 'Reception', true),
('EDCD3SYMZ', 'Ring Ceremony', true),
('EA9J6DXYP', 'Fashion Shoot', true),
('EM8BDLGM7', 'Pooja & Tilak', true),
('EVAHUN9RT', 'Court Wedding', true),
('EFY2XSXLG', 'Bride Groom Entry', true),
('EYXPBRHLL', 'House Entering Ceremony', true),
('EUH5NX5BS', 'Cake Cutting and Get Together', true),
('EFPMXNM9A', 'Groom Side Reception', true),
('E8SJFKWZT', 'Mappillai Azhaipu & Reception', true),
('E8PG3RVEW', 'Punjabi Wedding', true),
('EVP4P7JM3', 'Bride Side Sangeet', true),
('EFBUM9DJN', 'Event Coverage', true),
('E3M9WZRUX', 'Kerala Wedding', true),
('EDZ7PRCTD', 'Paat Bithai & Mayra', true),
('EJYE9QXV6', 'Bride Side Mehendi', true),
('EN6ZHZWMQ', 'Bharaat, Varmala, Phera', true),
('E5WSSCD95', '1st Birthday function', true),
('E58HTXF75', 'Parsi Wedding', true),
('E3HQ7PTW7', 'Special Event', true),
('E8WV5JURW', 'Roka', true),
('EZMNW9D6H', 'Pellikuthuru/Groom Welcoming/Bride Welcoming', true),
('EWPZCYQJ3', 'Bengali Wedding', true),
('EYZ825DPJ', 'Vinayak Pooja', true),
('E69XTFTZM', 'Thread Ceremony', true),
('E7FPC5K49', 'Haldi', true),
('E699B4NZD', 'Vara Pooja', true),
('E7NP8J7S7', 'Branding Work', true),
('E6YRE3VPW', 'Guru Pooja', true),
('EQ3ZHV648', 'Musical Night', true),
('EW9JUGVNG', 'Digital Marketing', true),
('EPRWDPAY8', 'Telugu Wedding', true),
('E43AZL27V', 'Haldi/Mehandi', true),
('EJXB4M4ZP', 'Maternity Shoot', true),
('E4RY5TUSC', 'Engagement/Haldi', true),
('EU5KTJ2MJ', 'Ayusha Homam', true),
('EB6CGQ9HE', 'Pooja', true),
('ERAW3WLQM', 'Sangeet/Mehandi', true),
('EKPFC4WRJ', 'Mehandi/Sundowner/Formal Dinner', true),
('ED8SQELAM', 'Puberty Function', true),
('ELEYW4R9R', 'Sangeet/Cocktail', true),
('EDSKARYYG', 'Mangalasnanam', true),
('EFM8CWVD9', 'Ganapathy Pooja', true),
('EVZCZQSDA', 'Penn Azhaippu / Mapillai Azhaippu / Engagement', true),
('EZSSHDM92', 'Bangle Function', true),
('EXAJRELA3', 'Mayara', true),
('EP6WWDFJF', 'Bride Entry', true),
('EFYMY5CXP', 'Cocktail / Reception', true),
('EZVVUDP84', 'Haldi/Engagement', true),
('EAXAW6VZQ', '25th Wedding Anniversary', true),
('EUQ4UYKPY', 'Nalangu Groom Side', true),
('ENMNDGGKF', 'Raj Tilak & Mehandi', true),
('EK6FARLTF', 'Groom Welcoming', true),
('EN9JV8826', 'Groom Side Sangeet', true),
('EBWYLV2HS', 'Vratham/Nichyathartham', true),
('EE64XACQB', 'Tamil Iyer Wedding', true),
('EUR5ES7FW', 'Kasi Yathirai', true),
('EVKLBWDZQ', 'Pool Party', true),
('EV9M6ZRSG', 'Bachelor''s Party', true),
('E57XSUTMZ', 'Temple Rituals', true),
('EJZAY8DST', 'Bridal Function', true),
('EHLE7GTGZ', 'Post Wedding Rituals', true),
('ELSVN4AW2', 'Groom Side Rituals', true),
('E9BTN77S8', 'Mangalasnanam', true),
('E9V798EVN', 'Pre Wedding Function (Bride)', true),
('E5WNKU5F9', 'Patni Seer', true),
('E7F846SW7', 'Bhajan', true),
('E9WF3N8Z9', 'Moong Bikhrai', true),
('EVHUFEC6L', 'Groom Side Blessing', true),
('E5T2MQJA4', 'Cocktail Party 2', true),
('EW7SVTHDJ', 'Lagnapatrika', true),
('ERCK5HVEY', 'Bride Side Haldi', true),
('ED6YTFQAP', 'Pandhakaal', true),
('ESURKMWWY', 'Pasupu Kottadam (Groom Side)', true),
('E62MJNBXK', 'Viratham/Vratham', true),
('ET4B79LQQ', 'Family Rituals', true),
('E43U9X4TY', 'Baby Shower', true),
('EN8FKKVEC', 'Baby Cradle Ceremony', true),
('E58Z7NCS5', 'Nikkah', true),
('EYY447N22', 'Homam', true),
('EEUBKMU2X', 'High Tea', true),
('EQB8RK9HQ', 'Prayer Meeting', true),
('EQE7HQMRV', 'Rituals & Wedding', true),
('EYWHKJJPX', 'Pre-Wedding Rituals', true),
('EZPD9GY73', 'Engagement & Sangeet', true),
('EHA6XHKFE', 'Bharaat, Varmala, Phera, Reception', true),
('E2R2QJME3', 'Sathyanarayana Pooja (Bride side)', true),
('EXWHQAZ2M', 'Reception/Wedding', true),
('E6AGA5ZBB', 'Nalangu & Vilayaadal', true),
('EVPM5HYPU', 'Bride Side Blessing', true),
('EGYNBNVLF', 'Bride Groom Ceremony', true),
('EMJERBKC9', 'Valima', true),
('ERDEQ6GKH', 'Rituals', true),
('ER9EG9FKW', 'Groom Side Haldi', true),
('ESJ3RUBS2', 'Engagement / Asheervaad', true),
('ERJ8FHRHF', 'Baby Baptism', true),
('EL87MAELP', 'Groom Side Mehendi', true),
('ESRLRW6MY', 'Nalangu', true),
('ELXZFC7PY', 'Bhaat', true),
('ENZNH9EA8', 'Concert Event', true),
('EKDNG27GG', 'Bride''s Pooja', true),
('E3R33D597', 'Nikasi', true),
('EVTXT8DEL', 'Haldi 2', true),
('E9GD94HQZ', 'Lagna Shastra', true),
('EYGVHZ58X', 'Sundowner', true),
('EXDAYTCX3', 'Engagement', true),
('EQNP4VTJ3', 'Penn Azhaipu', true),
('EYN66S86Y', 'Mehandi/Cocktail', true),
('E9JRFS9YX', 'Haldi/Sangeet', true),
('E95WXVS4Z', 'Carnival & Haldi', true),
('EU5EVP4D3', 'Bidaai', true),
('ED5SVRXAM', 'Outdoor photoshoot', true),
('ENMA65VFB', 'Sangeet', true),
('ESHWHHUUU', 'Naming Ceremony', true),
('EG98P64AY', 'sashtiapthapoorthi', true),
('ECHKGUF6U', 'Upanayanam', true),
('EJMRVMMJ6', 'Product Shoot', true),
('E7WQ8LCM2', 'Haldi/Pellikuthuru', true),
('EE2KBRTYA', 'Family Get together', true),
('EU5CECFNQ', 'Nagavalli', true),
('E365NBJV3', 'Ghee Pilai', true),
('EU2S344QF', 'Poochutum Vizha', true),
('EKWATK22L', 'House Warming', true),
('E3P8BKGBL', 'Baby Shoot Outdoor', true),
('E2BM2DWUJ', 'Groom Pandhakaal', true),
('E82HUTZWX', 'Tamil Wedding', true),
('EEMMWY478', 'Brahmin Wedding (Tamil)', true),
('E4N6MNXGA', 'Mehendi/Sangeet', true),
('EH3C3SBPN', 'Maruveedu', true),
('E88MX4Z5W', 'Mangalasnanam/Pellikoduku', true),
('E8YG25SYU', 'Bridal Shower', true),
('E5WT87JQZ', 'Pellikuthuru', true),
('EWJ38MD85', 'Bride Side Rituals', true),
('E3YABRJL2', 'Dinner/Sangeet', true),
('E3TBSSWER', 'Mehandi/Sangeet', true),
('EUNHRY3MM', 'Edurukolu', true),
('EKJ8YKH7B', 'North Indian Wedding', true),
('EKBW5GX2R', 'Temple Wedding', true),
('E3DNEGSSR', 'Cocktail Party', true),
('ERRYLA354', 'Bharaat, Sangeet, Dinner', true),
('EVHGN7T8E', 'Reception 2', true),
('EF8453HM3', 'Half Saree Function', true),
('E836UEDM6', 'Saree & Dhothi Function', true),
('EPJM4DJEH', 'Dinner Party', true),
('ECKAPAWBL', 'Carnival', true),
('EZZMUL2G8', 'Nalangu Bride Side', true),
('EFLE84FMP', 'Pelikoduku - Sangeet - Engagement - Edurkolu', true),
('E6GW2SNHN', 'Engagement or Betrothal or Nichayathartham', true),
('EGJZ7R9TY', 'Brahmin Wedding', true),
('ECU4VSU23', 'Baraat and Wedding', true),
('EV79TLB8T', 'Pradhanam', true),
('EL7NGRDGZ', 'Janavasam', true),
('ENW5F22ME', 'Seeru', true),
('E4SU5E2WE', 'Groom Entry', true),
('EQDPBJ34T', 'Decor Photography & Videography', true),
('EFUYKW78J', 'Traditional Event 1', true),
('EJRWTPY55', 'Wedding', true),
('EDKEB7QKN', '10th Anniversary', true),
('EQS4ZHLCK', 'Gowri Pooja & Kashi Yatra', true),
('ENBG5ARAX', 'Pasupu Kottadam (Bride Side)', true),
('E6597CG9G', 'Post Wedding shoot', true),
('EGB6BSXDG', 'Dhothi Ceremony', true),
('E29XT87G7', 'Engagement/Reception', true),
('E6AF8C8YN', 'Ganesh Sthapana, Mata Ji poojan & Mehendi', true);

COMMIT; 