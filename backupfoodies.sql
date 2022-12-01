-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 01 Des 2022 pada 17.01
-- Versi server: 10.4.24-MariaDB
-- Versi PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `backupfoodies`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `cart_table`
--

CREATE TABLE `cart_table` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `color` varchar(400) NOT NULL,
  `size` varchar(400) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `cart_table`
--

INSERT INTO `cart_table` (`cart_id`, `user_id`, `item_id`, `quantity`, `color`, `size`, `id_kategori`, `date`) VALUES
(1, 3, 2, 1, 'Original]', 'M]', 1, '2022-11-30'),
(2, 3, 2, 1, '[Hot', '[S', 1, '2022-11-30'),
(3, 3, 1, 10, 'original]', 'M', 1, '2022-11-30'),
(4, 1, 2, 1, '[Hot', '[S', 1, '2022-11-30'),
(5, 1, 1, 2, '[spicy', 'M', 1, '2022-11-30'),
(6, 1, 5, 1, '[Hot', 'M', 2, '2022-12-01'),
(7, 1, 5, 1, 'Cold]', 'M', 2, '2022-12-01'),
(8, 1, 2, 10, 'Original]', 'M]', 1, '2022-12-01'),
(9, 3, 2, 2, 'Original]', 'M]', 1, '2022-12-01'),
(10, 1, 1, 10, '[spicy', '[S', 1, '2022-12-01'),
(11, 1, 1, 3, 'original]', 'M', 1, '2022-12-01'),
(12, 1, 5, 1, 'Cold]', 'L]', 2, '2022-12-01'),
(13, 1, 2, 1, 'Original]', 'M]', 1, '2022-12-01'),
(14, 1, 1, 2, 'original]', 'M', 1, '2022-12-01'),
(15, 3, 2, 2, 'Original]', 'M]', 1, '2022-12-01');

-- --------------------------------------------------------

--
-- Struktur dari tabel `cart_table_temp`
--

CREATE TABLE `cart_table_temp` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `color` varchar(400) NOT NULL,
  `size` varchar(400) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Struktur dari tabel `items_table`
--

CREATE TABLE `items_table` (
  `item_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `rating` double NOT NULL,
  `tags` varchar(400) NOT NULL,
  `price` double NOT NULL,
  `sizes` varchar(400) NOT NULL,
  `colors` varchar(400) NOT NULL,
  `description` text NOT NULL,
  `image` text NOT NULL,
  `id_restrauran` int(11) NOT NULL,
  `kategori` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `items_table`
--

INSERT INTO `items_table` (`item_id`, `name`, `rating`, `tags`, `price`, `sizes`, `colors`, `description`, `image`, `id_restrauran`, `kategori`) VALUES
(1, 'Tonkotsu Ramen ', 3.5, '[noodle, soup]', 25000, '[S, M, L]', '[spicy, original]', 'Tonkotsu is a unique style of ramen consisting of an extremely rich, fatty pork broth, fresh noodles, soft-yolk eggs, and tender pork belly that melts', 'https://img.freepik.com/free-photo/japanese-seafood-ramen-with-cuttlefish-sauce_1205-9380.jpg?size=626&ext=jpg&ga=GA1.2.1760389070.1669119212&semt=sph', 1, 'makanan'),
(2, 'Ocha Tea', 4.8, '[GreenTea]', 15000, '[S, M]', '[Hot, Original]', 'It is traditionally made using bancha tea leaves and unpolished brown rice grains.', 'https://img.freepik.com/free-photo/top-view-green-matcha-beverage_23-2148296707.jpg?size=626&ext=jpg&ga=GA1.2.1760389070.1669119212&semt=sph', 1, 'minuman'),
(3, 'Shabu – Shabu', 4.2, '[Hotpot]', 23000, '[S, M]', '[Original]', 'Shabu Shabu is a popular Japanese-style hot pot where the meat and assorted vegetables are cooked in a flavorful broth called kombu dashi', 'https://img.freepik.com/free-photo/raw-meat-fresh-vegetable-hot-pot-shabu-menu_1150-35277.jpg?size=626&ext=jpg&ga=GA1.2.1760389070.1669119212&semt=sph', 1, 'makanan'),
(4, 'Kare', 4.2, '[Soup]', 45000, '[S, M]', '[Original]', 'Indian Food ', 'https://img.freepik.com/premium-photo/curry-rice-with-fried-pork-cutlet-creamy-omelet_1339-172388.jpg?size=626&ext=jpg&ga=GA1.2.1760389070.1669119212&semt=sph', 2, 'makanan'),
(5, 'Smoothies ', 5, '[Milk]', 20000, '[S, M, L]', '[Hot, Cold]', 'Smoothies are thick, creamy beverages usually blended from puréed fruits, vegetables, juices, yogurt, nuts, seeds, and/or dairy or nondairy milk.', 'https://img.freepik.com/free-photo/glass-papaya-juice-put-white-marble-floor_1150-28077.jpg?size=626&ext=jpg&ga=GA1.2.1760389070.1669119212&semt=sph', 2, 'minuman');

-- --------------------------------------------------------

--
-- Struktur dari tabel `kategori`
--

CREATE TABLE `kategori` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `kategori`
--

INSERT INTO `kategori` (`id_kategori`, `nama_kategori`) VALUES
(1, 'japanese'),
(2, 'indian');

-- --------------------------------------------------------

--
-- Struktur dari tabel `rekening`
--

CREATE TABLE `rekening` (
  `id_rekening` int(11) NOT NULL,
  `nomor_rekening` varchar(11) NOT NULL,
  `nama_tabungan` text NOT NULL,
  `saldo` double NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `rekening`
--

INSERT INTO `rekening` (`id_rekening`, `nomor_rekening`, `nama_tabungan`, `saldo`, `user_id`) VALUES
(1, '04330100413', 'Xtra Savers', 13976300, 1),
(3, '04330100413', 'Xtra Savers', 82000, 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `restaurant`
--

CREATE TABLE `restaurant` (
  `id_restrauran` int(11) NOT NULL,
  `name_res` text NOT NULL,
  `rating_rest` double NOT NULL,
  `alamat` text NOT NULL,
  `no_hp` varchar(400) NOT NULL,
  `images_res` text NOT NULL,
  `latitude` int(11) NOT NULL,
  `longitude` int(11) NOT NULL,
  `kapasitas` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `filter` enum('halal','non') NOT NULL DEFAULT 'halal',
  `jarak` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `restaurant`
--

INSERT INTO `restaurant` (`id_restrauran`, `name_res`, `rating_rest`, `alamat`, `no_hp`, `images_res`, `latitude`, `longitude`, `kapasitas`, `id_kategori`, `filter`, `jarak`) VALUES
(1, 'Furusato Izakaya', 4.8, 'Jakarta Selatan', '087843107171', 'https://img.freepik.com/premium-photo/empty-japanese-street-food-restaurant-side-view_23-2149410180.jpg?size=626&ext=jpg&ga=GA1.2.1760389070.1669119212&semt=sph', 0, 0, 30, 1, 'halal', 2),
(2, 'QUEEN’S OF INDIA ', 4, 'Jakarta Barat', '087843107122', 'https://img.freepik.com/free-vector/indian-cuisine-flat-banners-set_1284-9076.jpg?size=338&ext=jpg&ga=GA1.2.1760389070.1669119212&semt=sph', 0, 0, 20, 2, 'halal', 1),
(3, 'BOTTEGA RISTORANTE', 4.6, 'Jakarta Pusat', '087843107121', 'https://img.freepik.com/free-vector/detailed-barbecue-logo-template_23-2149008686.jpg?size=338&ext=jpg&ga=GA1.2.1760389070.1669119212&semt=sph', 0, 0, 0, 1, 'halal', 12),
(4, 'BATAVIA CAFFE', 5, 'Jakarta Pusat', '087843107171', 'https://img.freepik.com/free-photo/diet-health-nutrition-life-food-eating-concept_53876-120817.jpg?size=626&ext=jpg&ga=GA1.2.1760389070.1669119212&semt=sph', 0, 0, 34, 2, 'halal', 14);

-- --------------------------------------------------------

--
-- Struktur dari tabel `summary`
--

CREATE TABLE `summary` (
  `id_summary` int(11) NOT NULL,
  `cart_id` int(11) NOT NULL,
  `total` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `summary`
--

INSERT INTO `summary` (`id_summary`, `cart_id`, `total`) VALUES
(31, 2, 15000),
(32, 3, 280000),
(33, 4, 15000),
(34, 5, 50000),
(35, 6, 20000),
(36, 7, 20000),
(37, 8, 150000),
(38, 9, 30000),
(39, 10, 250000),
(40, 11, 75000),
(41, 12, 20000),
(42, 13, 15000),
(43, 14, 50000),
(44, 15, 30000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `id_transaksi` int(11) NOT NULL,
  `id_summary` int(11) NOT NULL,
  `trans_total` double NOT NULL,
  `trans_date` date NOT NULL,
  `trans_time` time NOT NULL,
  `jumlah_orang` int(11) NOT NULL,
  `id_rekening` int(11) NOT NULL,
  `kode_unik` int(11) NOT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`id_transaksi`, `id_summary`, `trans_total`, `trans_date`, `trans_time`, `jumlah_orang`, `id_rekening`, `kode_unik`, `user_id`) VALUES
(19, 6, 83600, '2022-11-30', '19:58:00', 12, 1, 6032, 1),
(20, 3, 308000, '2022-11-30', '23:49:00', 12, 1, 2783, 3),
(21, 4, 16500, '2022-11-30', '23:50:00', 2, 2, 3423, 1),
(22, 5, 55000, '2022-11-30', '23:58:00', 12, 1, 5033, 1),
(23, 6, 22000, '2022-12-01', '00:30:00', 2, 2, 5200, 1),
(24, 7, 22000, '2022-12-01', '12:01:00', 21, 1, 2187, 1),
(25, 8, 165000, '2022-12-01', '12:34:00', 12, 1, 9019, 1),
(26, 9, 33000, '2022-12-01', '13:42:00', 12, 1, 8268, 3),
(27, 10, 275000, '2022-12-01', '13:44:00', 12, 2, 3495, 1),
(28, 11, 82500, '2022-12-01', '14:41:00', 12, 1, 7834, 1),
(29, 12, 22000, '2022-12-01', '16:22:00', 12, 1, 3234, 1),
(30, 13, 23000, '2022-12-01', '16:27:00', 12, 1, 3662, 1),
(31, 14, 58000, '2022-12-01', '12:08:00', 12, 1, 5526, 1),
(32, 15, 38000, '2022-12-01', '22:58:00', 12, 1, 3357, 3);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users_table`
--

CREATE TABLE `users_table` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(400) NOT NULL,
  `user_email` varchar(400) NOT NULL,
  `user_password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data untuk tabel `users_table`
--

INSERT INTO `users_table` (`user_id`, `user_name`, `user_email`, `user_password`) VALUES
(1, 'Izaaz Azaam Syahalam', 'izaazsyahalam@gmail.com', 'ade78279ac9f7b66a1b7cbad4c9dfdb7'),
(3, 'catrinadia', 'catrinadia@gmail.com', 'ade78279ac9f7b66a1b7cbad4c9dfdb7'),
(4, 'Izaaz', 'izaaz@gmail.com', 'e10adc3949ba59abbe56e057f20f883e');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `cart_table`
--
ALTER TABLE `cart_table`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indeks untuk tabel `cart_table_temp`
--
ALTER TABLE `cart_table_temp`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indeks untuk tabel `items_table`
--
ALTER TABLE `items_table`
  ADD PRIMARY KEY (`item_id`);

--
-- Indeks untuk tabel `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `rekening`
--
ALTER TABLE `rekening`
  ADD PRIMARY KEY (`id_rekening`);

--
-- Indeks untuk tabel `restaurant`
--
ALTER TABLE `restaurant`
  ADD PRIMARY KEY (`id_restrauran`),
  ADD KEY `id_kategori` (`id_kategori`);

--
-- Indeks untuk tabel `summary`
--
ALTER TABLE `summary`
  ADD PRIMARY KEY (`id_summary`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`);

--
-- Indeks untuk tabel `users_table`
--
ALTER TABLE `users_table`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `cart_table`
--
ALTER TABLE `cart_table`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `cart_table_temp`
--
ALTER TABLE `cart_table_temp`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `items_table`
--
ALTER TABLE `items_table`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `rekening`
--
ALTER TABLE `rekening`
  MODIFY `id_rekening` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `restaurant`
--
ALTER TABLE `restaurant`
  MODIFY `id_restrauran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `summary`
--
ALTER TABLE `summary`
  MODIFY `id_summary` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT untuk tabel `users_table`
--
ALTER TABLE `users_table`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
