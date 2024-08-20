-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 19, 2024 at 09:48 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nugraha_market`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `total_harga_transaksi` ()   BEGIN
SELECT 
SUM(tb_keranjang.jumlah*tb_keranjang.harga) AS total_harga
FROM tb_keranjang;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(2, 'admin', '12345');

-- --------------------------------------------------------

--
-- Table structure for table `tb_databarang`
--

CREATE TABLE `tb_databarang` (
  `kode_barang` int(50) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(10) NOT NULL,
  `stok` int(10) NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_databarang`
--

INSERT INTO `tb_databarang` (`kode_barang`, `nama_barang`, `harga`, `stok`, `tanggal`) VALUES
(2025, 'LUX', 4000, 200, '2024-07-19'),
(2026, 'MIE', 1000, 2470, '2024-07-19');

-- --------------------------------------------------------

--
-- Table structure for table `tb_datapetugas`
--

CREATE TABLE `tb_datapetugas` (
  `id_petugas` int(11) NOT NULL,
  `nama_petugas` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `tanggal_pendaftaran` date NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tb_datapetugas`
--

INSERT INTO `tb_datapetugas` (`id_petugas`, `nama_petugas`, `email`, `alamat`, `tanggal_pendaftaran`, `username`, `password`) VALUES
(13, 'yopi', 'nugrha', 'bandung', '2024-07-10', 'admin', '12345');

-- --------------------------------------------------------

--
-- Table structure for table `tb_keranjang`
--

CREATE TABLE `tb_keranjang` (
  `id_transaksi` int(11) NOT NULL,
  `kode_barang` int(10) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(10) NOT NULL,
  `jumlah` int(10) NOT NULL,
  `total_harga` int(10) NOT NULL,
  `tgl_transaksi` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `tb_keranjang`
--
DELIMITER $$
CREATE TRIGGER `cancel` AFTER DELETE ON `tb_keranjang` FOR EACH ROW BEGIN
UPDATE tb_databarang SET
stok = stok + OLD.jumlah
WHERE kode_barang = OLD.kode_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cancel_2` AFTER DELETE ON `tb_keranjang` FOR EACH ROW BEGIN
DELETE FROM transaksi
WHERE kode_barang = OLD.kode_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `stok_habis` AFTER INSERT ON `tb_keranjang` FOR EACH ROW BEGIN
DELETE FROM tb_databarang
WHERE stok = 0
AND
kode_barang = NEW.kode_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `tgl_transaksi` date NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `kode_barang` int(50) NOT NULL,
  `nama_barang` varchar(50) NOT NULL,
  `harga` int(11) NOT NULL,
  `jumlah_barang` int(10) NOT NULL,
  `total_harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `transaksi`
--
DELIMITER $$
CREATE TRIGGER `keranjang` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
INSERT INTO tb_keranjang SET
id_transaksi = NEW.id_transaksi,
kode_barang = NEW.kode_barang,
nama_barang = NEW.nama_barang,
harga = NEW.harga,
jumlah = NEW.jumlah_barang,
total_harga = NEW.total_harga,
tgl_transaksi = NEW.tgl_transaksi;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `transaksi` AFTER INSERT ON `transaksi` FOR EACH ROW BEGIN
UPDATE tb_databarang SET
stok = stok - NEW.jumlah_barang
WHERE kode_barang = NEW.kode_barang;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tb_databarang`
--
ALTER TABLE `tb_databarang`
  ADD PRIMARY KEY (`kode_barang`);

--
-- Indexes for table `tb_datapetugas`
--
ALTER TABLE `tb_datapetugas`
  ADD PRIMARY KEY (`id_petugas`);

--
-- Indexes for table `tb_keranjang`
--
ALTER TABLE `tb_keranjang`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `kode_barang` (`kode_barang`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id_transaksi`),
  ADD KEY `kode_barang` (`kode_barang`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `tb_databarang`
--
ALTER TABLE `tb_databarang`
  MODIFY `kode_barang` int(50) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2027;

--
-- AUTO_INCREMENT for table `tb_datapetugas`
--
ALTER TABLE `tb_datapetugas`
  MODIFY `id_petugas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tb_keranjang`
--
ALTER TABLE `tb_keranjang`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id_transaksi` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
