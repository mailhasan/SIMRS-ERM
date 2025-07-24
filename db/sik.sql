/*
SQLyog Ultimate v12.5.1 (32 bit)
MySQL - 10.6.22-MariaDB-0ubuntu0.22.04.1 : Database - sikDrSalim1
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`sikDrSalim1` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `sikDrSalim1`;

/*Table structure for table `bayar_operasi_dokter_anak` */

DROP TABLE IF EXISTS `bayar_operasi_dokter_anak`;

CREATE TABLE `bayar_operasi_dokter_anak` (
  `no_bayar` varchar(30) NOT NULL DEFAULT '',
  `no_rawat` varchar(17) NOT NULL,
  `kode_paket` varchar(15) NOT NULL,
  `tgl_operasi` datetime NOT NULL,
  `biayadokter_anak` double NOT NULL,
  PRIMARY KEY (`no_rawat`,`tgl_operasi`,`kode_paket`,`no_bayar`),
  KEY `no_rawat` (`no_rawat`),
  KEY `no_bayar` (`no_bayar`),
  KEY `kode_paket` (`kode_paket`),
  CONSTRAINT `bayar_operasi_dokter_anak_ibfk_1` FOREIGN KEY (`no_rawat`) REFERENCES `reg_periksa` (`no_rawat`) ON UPDATE CASCADE,
  CONSTRAINT `bayar_operasi_dokter_anak_ibfk_2` FOREIGN KEY (`no_bayar`) REFERENCES `bayar_jm_dokter` (`no_bayar`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bayar_operasi_dokter_anak_ibfk_3` FOREIGN KEY (`kode_paket`) REFERENCES `paket_operasi` (`kode_paket`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `bayar_operasi_dokter_anak` */

/*Table structure for table `bayar_operasi_dokter_anestesi` */

DROP TABLE IF EXISTS `bayar_operasi_dokter_anestesi`;

CREATE TABLE `bayar_operasi_dokter_anestesi` (
  `no_bayar` varchar(30) NOT NULL DEFAULT '',
  `no_rawat` varchar(17) NOT NULL,
  `kode_paket` varchar(15) NOT NULL,
  `tgl_operasi` datetime NOT NULL,
  `biayadokter_anestesi` double NOT NULL,
  PRIMARY KEY (`no_rawat`,`tgl_operasi`,`kode_paket`,`no_bayar`),
  KEY `no_rawat` (`no_rawat`),
  KEY `no_bayar` (`no_bayar`),
  KEY `kode_paket` (`kode_paket`),
  CONSTRAINT `bayar_operasi_dokter_anestesi_ibfk_1` FOREIGN KEY (`no_rawat`) REFERENCES `reg_periksa` (`no_rawat`) ON UPDATE CASCADE,
  CONSTRAINT `bayar_operasi_dokter_anestesi_ibfk_2` FOREIGN KEY (`no_bayar`) REFERENCES `bayar_jm_dokter` (`no_bayar`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bayar_operasi_dokter_anestesi_ibfk_3` FOREIGN KEY (`kode_paket`) REFERENCES `paket_operasi` (`kode_paket`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `bayar_operasi_dokter_anestesi` */

/*Table structure for table `bayar_operasi_dokter_pjanak` */

DROP TABLE IF EXISTS `bayar_operasi_dokter_pjanak`;

CREATE TABLE `bayar_operasi_dokter_pjanak` (
  `no_bayar` varchar(30) NOT NULL DEFAULT '',
  `no_rawat` varchar(17) NOT NULL,
  `kode_paket` varchar(15) NOT NULL,
  `tgl_operasi` datetime NOT NULL,
  `biaya_dokter_pjanak` double NOT NULL,
  PRIMARY KEY (`no_rawat`,`tgl_operasi`,`kode_paket`,`no_bayar`),
  KEY `no_rawat` (`no_rawat`),
  KEY `no_bayar` (`no_bayar`),
  KEY `kode_paket` (`kode_paket`),
  CONSTRAINT `bayar_operasi_dokter_pjanak_ibfk_1` FOREIGN KEY (`no_rawat`) REFERENCES `reg_periksa` (`no_rawat`) ON UPDATE CASCADE,
  CONSTRAINT `bayar_operasi_dokter_pjanak_ibfk_2` FOREIGN KEY (`no_bayar`) REFERENCES `bayar_jm_dokter` (`no_bayar`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bayar_operasi_dokter_pjanak_ibfk_3` FOREIGN KEY (`kode_paket`) REFERENCES `paket_operasi` (`kode_paket`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `bayar_operasi_dokter_pjanak` */

/*Table structure for table `bayar_operasi_dokter_umum` */

DROP TABLE IF EXISTS `bayar_operasi_dokter_umum`;

CREATE TABLE `bayar_operasi_dokter_umum` (
  `no_bayar` varchar(30) NOT NULL DEFAULT '',
  `no_rawat` varchar(17) NOT NULL,
  `kode_paket` varchar(15) NOT NULL,
  `tgl_operasi` datetime NOT NULL,
  `biaya_dokter_umum` double NOT NULL,
  PRIMARY KEY (`no_rawat`,`tgl_operasi`,`kode_paket`,`no_bayar`),
  KEY `no_rawat` (`no_rawat`),
  KEY `no_bayar` (`no_bayar`),
  KEY `kode_paket` (`kode_paket`),
  CONSTRAINT `bayar_operasi_dokter_umum_ibfk_1` FOREIGN KEY (`no_rawat`) REFERENCES `reg_periksa` (`no_rawat`) ON UPDATE CASCADE,
  CONSTRAINT `bayar_operasi_dokter_umum_ibfk_2` FOREIGN KEY (`no_bayar`) REFERENCES `bayar_jm_dokter` (`no_bayar`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `bayar_operasi_dokter_umum_ibfk_3` FOREIGN KEY (`kode_paket`) REFERENCES `paket_operasi` (`kode_paket`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `bayar_operasi_dokter_umum` */

/*Table structure for table `maping_dokter_dpjpvclaim` */

DROP TABLE IF EXISTS `maping_dokter_dpjpvclaim`;

CREATE TABLE `maping_dokter_dpjpvclaim` (
  `kd_dokter` varchar(20) NOT NULL,
  `kd_dokter_bpjs` varchar(20) DEFAULT NULL,
  `nm_dokter_bpjs` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`kd_dokter`),
  CONSTRAINT `maping_dokter_dpjpvclaim_ibfk_1` FOREIGN KEY (`kd_dokter`) REFERENCES `dokter` (`kd_dokter`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `maping_dokter_dpjpvclaim` */

/*Table structure for table `maping_dokter_pcare` */

DROP TABLE IF EXISTS `maping_dokter_pcare`;

CREATE TABLE `maping_dokter_pcare` (
  `kd_dokter` varchar(20) NOT NULL,
  `kd_dokter_pcare` varchar(20) DEFAULT NULL,
  `nm_dokter_pcare` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`kd_dokter`),
  CONSTRAINT `maping_dokter_pcare_ibfk_1` FOREIGN KEY (`kd_dokter`) REFERENCES `dokter` (`kd_dokter`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `maping_dokter_pcare` */

insert  into `maping_dokter_pcare`(`kd_dokter`,`kd_dokter_pcare`,`nm_dokter_pcare`) values 
('D0000004','1','dr. Siti Mahfudah');

/*Table structure for table `resep_dokter_racikan` */

DROP TABLE IF EXISTS `resep_dokter_racikan`;

CREATE TABLE `resep_dokter_racikan` (
  `no_resep` varchar(14) NOT NULL,
  `no_racik` varchar(2) NOT NULL,
  `nama_racik` varchar(100) NOT NULL,
  `kd_racik` varchar(3) NOT NULL,
  `jml_dr` int(11) NOT NULL,
  `aturan_pakai` varchar(150) NOT NULL,
  `keterangan` varchar(50) NOT NULL,
  PRIMARY KEY (`no_resep`,`no_racik`),
  KEY `kd_racik` (`kd_racik`),
  CONSTRAINT `resep_dokter_racikan_ibfk_1` FOREIGN KEY (`no_resep`) REFERENCES `resep_obat` (`no_resep`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `resep_dokter_racikan_ibfk_2` FOREIGN KEY (`kd_racik`) REFERENCES `metode_racik` (`kd_racik`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `resep_dokter_racikan` */

insert  into `resep_dokter_racikan`(`no_resep`,`no_racik`,`nama_racik`,`kd_racik`,`jml_dr`,`aturan_pakai`,`keterangan`) values 
('202411160003','1','R1','R01',18,'2 X 1','HABISKAN'),
('202411190001','1','R1','R01',18,'4 x 1 pagi','HABISKAN'),
('202411210003','1','R1','R01',18,'4 x 1 pagi','HABISKAN'),
('202411260003','1','R1','R01',18,'2 X 1','-'),
('202411260004','1','R1','R01',18,'3 x 1','-'),
('202411260008','1','R1','R01',18,'3 x 1','-'),
('202412050001','1','R1','R01',10,'2 X 1','-'),
('202412100004','1','R1','R01',16,'3 x 1','-'),
('202412100004','2','R2','R01',18,'2 X 1','-'),
('202412110001','1','R 1','R01',10,'2 X 1','-'),
('202412110001','2','R 2','R01',15,'3 x 1','-'),
('202412110002','1','R1','R01',16,'3 x 1','-'),
('202412110002','2','R2','R01',18,'2 X 1','-'),
('202412170003','1','R1','R01',10,'2 X 1','-'),
('202412200001','1','R 1','R01',10,'2 X 1','-'),
('202412200001','2','R 2','R01',15,'3 x 1','-'),
('202412200002','1','R 1','R01',10,'2 X 1','-'),
('202412200002','2','R 2','R01',15,'3 x 1','-'),
('202412200004','1','R1','R01',18,'3 x 1','-'),
('202412200005','1','R1','R01',10,'2 X 1','-'),
('202412200006','1','R1','R01',10,'2 X 1','-');

/*Table structure for table `resep_dokter_racikan_detail` */

DROP TABLE IF EXISTS `resep_dokter_racikan_detail`;

CREATE TABLE `resep_dokter_racikan_detail` (
  `no_resep` varchar(14) NOT NULL,
  `no_racik` varchar(2) NOT NULL,
  `kode_brng` varchar(15) NOT NULL,
  `p1` double DEFAULT NULL,
  `p2` double DEFAULT NULL,
  `kandungan` varchar(10) DEFAULT NULL,
  `jml` double DEFAULT NULL,
  PRIMARY KEY (`no_resep`,`no_racik`,`kode_brng`),
  KEY `kode_brng` (`kode_brng`),
  CONSTRAINT `resep_dokter_racikan_detail_ibfk_1` FOREIGN KEY (`no_resep`) REFERENCES `resep_obat` (`no_resep`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `resep_dokter_racikan_detail_ibfk_2` FOREIGN KEY (`kode_brng`) REFERENCES `databarang` (`kode_brng`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `resep_dokter_racikan_detail` */

insert  into `resep_dokter_racikan_detail`(`no_resep`,`no_racik`,`kode_brng`,`p1`,`p2`,`kandungan`,`jml`) values 
('202411160003','1','B000000305',1,1,'45',11.6),
('202411160003','1','B000000556',1,1,'30%',2.1),
('202411160003','1','B000001207',2,3,'33.3',12),
('202411190001','1','B000000556',2,3,'133.3',12),
('202411190001','1','B000001207',1,1,'35',12.6),
('202411210003','1','B000000556',2,3,'133.3',12),
('202411210003','1','B000001207',1,1,'35',12.6),
('202411260003','1','B000000305',1,1,'47',12.1),
('202411260003','1','B000000556',1,1,'30%',2.2),
('202411260003','1','B000001207',2,3,'33.3',12),
('202411260004','1','B000000305',2,3,'46.7',12),
('202411260004','1','B000001207',1,1,'35',12.6),
('202411260008','1','B000000305',2,3,'46.7',12),
('202411260008','1','B000001207',1,1,'35',12.6),
('202412050001','1','B000000305',1,1,'45',6.4),
('202412050001','1','B000000556',2,3,'133.3',6.7),
('202412100004','1','B000001512',1,1,'120',9.6),
('202412100004','1','B000001659',2,3,'40.0',10.7),
('202412100004','2','B000000556',1,1,'130',11.7),
('202412100004','2','B000001519',2,3,'66.7',12),
('202412110001','1','B000000556',1,1,'200.0',7),
('202412110001','1','B000001207',2,3,'33.3',6.7),
('202412110001','2','B000000554',1,1,'78',7.8),
('202412110001','2','B00001000',2,3,'133.3',10),
('202412110002','1','B000001512',1,1,'120',9.6),
('202412110002','1','B000001659',2,3,'40.0',10.7),
('202412110002','2','B000000556',1,1,'130',11.7),
('202412110002','2','B000001519',2,3,'66.7',12),
('202412170003','1','B000000305',1,1,'55',7.9),
('202412170003','1','B000001207',2,3,'33.3',6.7),
('202412200001','2','B000000554',1,1,'78',7.8),
('202412200001','2','B00001000',2,3,'133.3',10),
('202412200002','2','B00001000',2,3,'133.3',10),
('202412200004','1','B000000556',2,3,'133.3',12),
('202412200004','1','B000001207',1,1,'37',13.3),
('202412200004','1','B000001659',1,1,'30%',15.3),
('202412200005','1','B000000305',1,1,'55',7.9),
('202412200005','1','B000001207',2,3,'33.3',6.7),
('202412200006','1','B000000305',1,1,'55',7.9),
('202412200006','1','B000001207',2,3,'33.3',6.7);

/*Table structure for table `rujukanranap_dokter_rs` */

DROP TABLE IF EXISTS `rujukanranap_dokter_rs`;

CREATE TABLE `rujukanranap_dokter_rs` (
  `tanggal` date NOT NULL,
  `kd_dokter` varchar(20) NOT NULL,
  `no_rkm_medis` varchar(15) NOT NULL,
  `kd_kamar` varchar(15) NOT NULL,
  `jasarujuk` double NOT NULL,
  PRIMARY KEY (`tanggal`,`kd_dokter`,`no_rkm_medis`,`kd_kamar`),
  KEY `no_rkm_medis` (`no_rkm_medis`),
  KEY `kd_kamar` (`kd_kamar`),
  KEY `rujukanranap_dokter_rs_ibfk_1` (`kd_dokter`),
  CONSTRAINT `rujukanranap_dokter_rs_ibfk_1` FOREIGN KEY (`kd_dokter`) REFERENCES `dokter` (`kd_dokter`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `rujukanranap_dokter_rs_ibfk_2` FOREIGN KEY (`no_rkm_medis`) REFERENCES `pasien` (`no_rkm_medis`) ON UPDATE CASCADE,
  CONSTRAINT `rujukanranap_dokter_rs_ibfk_3` FOREIGN KEY (`kd_kamar`) REFERENCES `kamar` (`kd_kamar`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `rujukanranap_dokter_rs` */

/*Table structure for table `template_pemeriksaan_dokter_detail_permintaan_lab` */

DROP TABLE IF EXISTS `template_pemeriksaan_dokter_detail_permintaan_lab`;

CREATE TABLE `template_pemeriksaan_dokter_detail_permintaan_lab` (
  `no_template` varchar(20) NOT NULL,
  `kd_jenis_prw` varchar(15) NOT NULL,
  `id_template` int(11) NOT NULL,
  PRIMARY KEY (`no_template`,`kd_jenis_prw`,`id_template`),
  KEY `kd_jenis_prw` (`kd_jenis_prw`),
  KEY `id_template` (`id_template`),
  CONSTRAINT `template_pemeriksaan_dokter_detail_permintaan_lab_ibfk_1` FOREIGN KEY (`no_template`) REFERENCES `template_pemeriksaan_dokter` (`no_template`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_detail_permintaan_lab_ibfk_2` FOREIGN KEY (`kd_jenis_prw`) REFERENCES `jns_perawatan_lab` (`kd_jenis_prw`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_detail_permintaan_lab_ibfk_3` FOREIGN KEY (`id_template`) REFERENCES `template_laboratorium` (`id_template`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `template_pemeriksaan_dokter_detail_permintaan_lab` */

insert  into `template_pemeriksaan_dokter_detail_permintaan_lab`(`no_template`,`kd_jenis_prw`,`id_template`) values 
('TPD0000000000000008','102-K.2',665),
('TPD0000000000000008','102-K.2',666),
('TPD0000000000000008','102-K.2',667),
('TPD0000000000000008','102-K.2',668),
('TPD0000000000000008','102-K.2',669),
('TPD0000000000000008','102-K.2',670),
('TPD0000000000000008','102-K.2',671),
('TPD0000000000000008','102-K.2',672),
('TPD0000000000000008','102-K.2',673),
('TPD0000000000000008','102-K.2',674),
('TPD0000000000000008','102-K.2',675),
('TPD0000000000000008','102-K.2',2198),
('TPD0000000000000008','102-K.2',2199),
('TPD0000000000000008','102-K.2',2200),
('TPD0000000000000008','102-K.2',2201),
('TPD0000000000000008','102-K.2',2202),
('TPD0000000000000009','102-K.2',665),
('TPD0000000000000009','102-K.2',666),
('TPD0000000000000009','102-K.2',667),
('TPD0000000000000009','102-K.2',668),
('TPD0000000000000009','102-K.2',669),
('TPD0000000000000009','102-K.2',670),
('TPD0000000000000009','102-K.2',671),
('TPD0000000000000009','102-K.2',672),
('TPD0000000000000009','102-K.2',673),
('TPD0000000000000009','102-K.2',674),
('TPD0000000000000009','102-K.2',675),
('TPD0000000000000009','102-K.2',2198),
('TPD0000000000000009','102-K.2',2199),
('TPD0000000000000009','102-K.2',2200),
('TPD0000000000000009','102-K.2',2201),
('TPD0000000000000009','102-K.2',2202);

/*Table structure for table `template_pemeriksaan_dokter_penyakit` */

DROP TABLE IF EXISTS `template_pemeriksaan_dokter_penyakit`;

CREATE TABLE `template_pemeriksaan_dokter_penyakit` (
  `no_template` varchar(20) NOT NULL,
  `kd_penyakit` varchar(15) NOT NULL,
  `urut` int(11) NOT NULL,
  PRIMARY KEY (`no_template`,`kd_penyakit`),
  KEY `kd_penyakit` (`kd_penyakit`),
  CONSTRAINT `template_pemeriksaan_dokter_penyakit_ibfk_1` FOREIGN KEY (`no_template`) REFERENCES `template_pemeriksaan_dokter` (`no_template`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_penyakit_ibfk_2` FOREIGN KEY (`kd_penyakit`) REFERENCES `penyakit` (`kd_penyakit`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `template_pemeriksaan_dokter_penyakit` */

insert  into `template_pemeriksaan_dokter_penyakit`(`no_template`,`kd_penyakit`,`urut`) values 
('TPD0000000000000001','A02.0',1),
('TPD0000000000000002','I50.0',1),
('TPD0000000000000003','A15.1',1),
('TPD0000000000000004','A01',1),
('TPD0000000000000005','A01.1',1),
('TPD0000000000000008','A01.0',1),
('TPD0000000000000009','I50.0',1);

/*Table structure for table `template_pemeriksaan_dokter_permintaan_lab` */

DROP TABLE IF EXISTS `template_pemeriksaan_dokter_permintaan_lab`;

CREATE TABLE `template_pemeriksaan_dokter_permintaan_lab` (
  `no_template` varchar(20) NOT NULL,
  `kd_jenis_prw` varchar(15) NOT NULL,
  PRIMARY KEY (`no_template`,`kd_jenis_prw`),
  KEY `kd_jenis_prw` (`kd_jenis_prw`),
  CONSTRAINT `template_pemeriksaan_dokter_permintaan_lab_ibfk_1` FOREIGN KEY (`no_template`) REFERENCES `template_pemeriksaan_dokter` (`no_template`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_permintaan_lab_ibfk_2` FOREIGN KEY (`kd_jenis_prw`) REFERENCES `jns_perawatan_lab` (`kd_jenis_prw`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `template_pemeriksaan_dokter_permintaan_lab` */

insert  into `template_pemeriksaan_dokter_permintaan_lab`(`no_template`,`kd_jenis_prw`) values 
('TPD0000000000000008','102-K.2'),
('TPD0000000000000009','102-K.2');

/*Table structure for table `template_pemeriksaan_dokter_permintaan_radiologi` */

DROP TABLE IF EXISTS `template_pemeriksaan_dokter_permintaan_radiologi`;

CREATE TABLE `template_pemeriksaan_dokter_permintaan_radiologi` (
  `no_template` varchar(20) NOT NULL,
  `kd_jenis_prw` varchar(15) NOT NULL,
  PRIMARY KEY (`no_template`,`kd_jenis_prw`),
  KEY `kd_jenis_prw` (`kd_jenis_prw`),
  CONSTRAINT `template_pemeriksaan_dokter_permintaan_radiologi_ibfk_1` FOREIGN KEY (`no_template`) REFERENCES `template_pemeriksaan_dokter` (`no_template`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_permintaan_radiologi_ibfk_2` FOREIGN KEY (`kd_jenis_prw`) REFERENCES `jns_perawatan_radiologi` (`kd_jenis_prw`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `template_pemeriksaan_dokter_permintaan_radiologi` */

insert  into `template_pemeriksaan_dokter_permintaan_radiologi`(`no_template`,`kd_jenis_prw`) values 
('TPD0000000000000001','IG.AS- 1'),
('TPD0000000000000004','IG.AS- 1'),
('TPD0000000000000005','IG.AS- 1'),
('TPD0000000000000006','ICU.CTO-01');

/*Table structure for table `template_pemeriksaan_dokter_prosedur` */

DROP TABLE IF EXISTS `template_pemeriksaan_dokter_prosedur`;

CREATE TABLE `template_pemeriksaan_dokter_prosedur` (
  `no_template` varchar(20) NOT NULL,
  `kode` varchar(8) NOT NULL,
  `urut` int(11) NOT NULL,
  PRIMARY KEY (`no_template`,`kode`),
  KEY `kode` (`kode`),
  CONSTRAINT `template_pemeriksaan_dokter_prosedur_ibfk_1` FOREIGN KEY (`no_template`) REFERENCES `template_pemeriksaan_dokter` (`no_template`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_prosedur_ibfk_2` FOREIGN KEY (`kode`) REFERENCES `icd9` (`kode`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `template_pemeriksaan_dokter_prosedur` */

insert  into `template_pemeriksaan_dokter_prosedur`(`no_template`,`kode`,`urut`) values 
('TPD0000000000000001','00.55',1),
('TPD0000000000000001','00.77',2),
('TPD0000000000000004','00.02',1);

/*Table structure for table `template_pemeriksaan_dokter_resep` */

DROP TABLE IF EXISTS `template_pemeriksaan_dokter_resep`;

CREATE TABLE `template_pemeriksaan_dokter_resep` (
  `no_template` varchar(20) NOT NULL,
  `kode_brng` varchar(15) NOT NULL,
  `jml` double DEFAULT NULL,
  `aturan_pakai` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`no_template`,`kode_brng`),
  KEY `kode_brng` (`kode_brng`),
  CONSTRAINT `template_pemeriksaan_dokter_resep_ibfk_1` FOREIGN KEY (`no_template`) REFERENCES `template_pemeriksaan_dokter` (`no_template`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_resep_ibfk_2` FOREIGN KEY (`kode_brng`) REFERENCES `databarang` (`kode_brng`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `template_pemeriksaan_dokter_resep` */

insert  into `template_pemeriksaan_dokter_resep`(`no_template`,`kode_brng`,`jml`,`aturan_pakai`) values 
('TPD0000000000000004','B000000571',10,'3 x 1'),
('TPD0000000000000004','B000000790',10,'2 x 1'),
('TPD0000000000000007','A000000074',1,''),
('TPD0000000000000007','B000000003',1,''),
('TPD0000000000000007','B000000340',5,''),
('TPD0000000000000008','B000000305',10,'3 x 1'),
('TPD0000000000000008','B000000571',10,'3 x 1'),
('TPD0000000000000009','B000000305',10,'3 x 1'),
('TPD0000000000000009','B000000571',10,'3 x 1');

/*Table structure for table `template_pemeriksaan_dokter_resep_racikan` */

DROP TABLE IF EXISTS `template_pemeriksaan_dokter_resep_racikan`;

CREATE TABLE `template_pemeriksaan_dokter_resep_racikan` (
  `no_template` varchar(20) NOT NULL,
  `no_racik` varchar(2) NOT NULL,
  `nama_racik` varchar(100) DEFAULT NULL,
  `kd_racik` varchar(3) DEFAULT NULL,
  `jml_dr` int(11) DEFAULT NULL,
  `aturan_pakai` varchar(150) DEFAULT NULL,
  `keterangan` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`no_template`,`no_racik`),
  KEY `kd_racik` (`kd_racik`),
  CONSTRAINT `template_pemeriksaan_dokter_resep_racikan_ibfk_1` FOREIGN KEY (`no_template`) REFERENCES `template_pemeriksaan_dokter` (`no_template`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_resep_racikan_ibfk_2` FOREIGN KEY (`kd_racik`) REFERENCES `metode_racik` (`kd_racik`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `template_pemeriksaan_dokter_resep_racikan` */

insert  into `template_pemeriksaan_dokter_resep_racikan`(`no_template`,`no_racik`,`nama_racik`,`kd_racik`,`jml_dr`,`aturan_pakai`,`keterangan`) values 
('TPD0000000000000009','1','R 1','R01',10,'2 X 1','-'),
('TPD0000000000000009','2','R 2','R01',15,'3 x 1','-');

/*Table structure for table `template_pemeriksaan_dokter_resep_racikan_detail` */

DROP TABLE IF EXISTS `template_pemeriksaan_dokter_resep_racikan_detail`;

CREATE TABLE `template_pemeriksaan_dokter_resep_racikan_detail` (
  `no_template` varchar(20) NOT NULL,
  `no_racik` varchar(2) NOT NULL,
  `kode_brng` varchar(15) NOT NULL,
  `p1` double DEFAULT NULL,
  `p2` double DEFAULT NULL,
  `kandungan` varchar(10) DEFAULT NULL,
  `jml` double DEFAULT NULL,
  PRIMARY KEY (`no_template`,`no_racik`,`kode_brng`),
  KEY `kode_brng` (`kode_brng`),
  CONSTRAINT `template_pemeriksaan_dokter_resep_racikan_detail_ibfk_1` FOREIGN KEY (`no_template`) REFERENCES `template_pemeriksaan_dokter` (`no_template`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_resep_racikan_detail_ibfk_2` FOREIGN KEY (`kode_brng`) REFERENCES `databarang` (`kode_brng`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `template_pemeriksaan_dokter_resep_racikan_detail` */

insert  into `template_pemeriksaan_dokter_resep_racikan_detail`(`no_template`,`no_racik`,`kode_brng`,`p1`,`p2`,`kandungan`,`jml`) values 
('TPD0000000000000009','2','B000000554',1,1,'78',7.8),
('TPD0000000000000009','2','B00001000',2,3,'133.3',10);

/*Table structure for table `template_pemeriksaan_dokter_tindakan` */

DROP TABLE IF EXISTS `template_pemeriksaan_dokter_tindakan`;

CREATE TABLE `template_pemeriksaan_dokter_tindakan` (
  `no_template` varchar(20) NOT NULL,
  `kd_jenis_prw` varchar(15) NOT NULL,
  PRIMARY KEY (`no_template`,`kd_jenis_prw`),
  KEY `kd_jenis_prw` (`kd_jenis_prw`),
  CONSTRAINT `template_pemeriksaan_dokter_tindakan_ibfk_1` FOREIGN KEY (`kd_jenis_prw`) REFERENCES `jns_perawatan` (`kd_jenis_prw`) ON UPDATE CASCADE,
  CONSTRAINT `template_pemeriksaan_dokter_tindakan_ibfk_2` FOREIGN KEY (`no_template`) REFERENCES `template_pemeriksaan_dokter` (`no_template`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

/*Data for the table `template_pemeriksaan_dokter_tindakan` */

insert  into `template_pemeriksaan_dokter_tindakan`(`no_template`,`kd_jenis_prw`) values 
('TPD0000000000000004','C001'),
('TPD0000000000000004','C102'),
('TPD0000000000000005','RJ00861'),
('TPD0000000000000009','C370'),
('TPD0000000000000009','C515'),
('TPD0000000000000009','RJ00002'),
('TPD0000000000000009','RJ00864');

/*Table structure for table `detail_obat_formbpjs` */

DROP TABLE IF EXISTS `detail_obat_formbpjs`;

/*!50001 DROP VIEW IF EXISTS `detail_obat_formbpjs` */;
/*!50001 DROP TABLE IF EXISTS `detail_obat_formbpjs` */;

/*!50001 CREATE TABLE  `detail_obat_formbpjs`(
 `no_rawat` varchar(17) ,
 `tgl_perawatan` date ,
 `no_resep` varchar(14) ,
 `kode_brng` varchar(15) ,
 `nama_brng` varchar(80) ,
 `biaya_obat` double ,
 `jml` double ,
 `total` double ,
 `aturan` varchar(150) 
)*/;

/*View structure for view detail_obat_formbpjs */

/*!50001 DROP TABLE IF EXISTS `detail_obat_formbpjs` */;
/*!50001 DROP VIEW IF EXISTS `detail_obat_formbpjs` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`admin`@`%` SQL SECURITY DEFINER VIEW `detail_obat_formbpjs` AS select `A`.`no_rawat` AS `no_rawat`,`B`.`tgl_perawatan` AS `tgl_perawatan`,`A`.`no_resep` AS `no_resep`,`B`.`kode_brng` AS `kode_brng`,`C`.`nama_brng` AS `nama_brng`,`B`.`biaya_obat` AS `biaya_obat`,`B`.`jml` AS `jml`,`B`.`total` AS `total`,`D`.`aturan` AS `aturan` from (((`resep_obat` `A` join `detail_pemberian_obat` `B` on(`A`.`no_rawat` = `B`.`no_rawat` and `A`.`tgl_perawatan` = `B`.`tgl_perawatan`)) join `databarang` `C` on(`B`.`kode_brng` = `C`.`kode_brng`)) join `aturan_pakai` `D` on(`C`.`kode_brng` = `D`.`kode_brng` and `B`.`no_rawat` = `D`.`no_rawat` and `B`.`tgl_perawatan` = `D`.`tgl_perawatan`)) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
