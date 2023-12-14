CREATE DATABASE toko_hewan_ceria;

CREATE TABLE Kategori_Hewan (
    id_kategori_hewan INT(11) PRIMARY KEY,
    nama_kategori_hewan VARCHAR(256)
);

CREATE TABLE Kategori_Pakan (
    id_kategori_pakan INT(11) PRIMARY KEY,
    nama_kategori_pakan VARCHAR(256)
);

CREATE TABLE Staff (
    id_staff INT(11) PRIMARY KEY,
    nama_staff VARCHAR(256),
    alamat_staff VARCHAR(256),
    email_staff VARCHAR(256)
);

CREATE TABLE Hewan (
    id_hewan INT(11) PRIMARY KEY NOT NULL,
    jenis_hewan VARCHAR(256),
    tipe_hewan VARCHAR(256),
    harga_hewan INT(11),
    stok_hewan VARCHAR(256),
    deskripsi_hewan TEXT,
    id_kategori_hewan INT(11),
    FOREIGN KEY (id_kategori_hewan) REFERENCES Kategori_Hewan(id_kategori_hewan)
);

CREATE TABLE Customer (
    id_customer INT(11) PRIMARY KEY,
    nama_customer VARCHAR(256),
    alamat_customer VARCHAR(256),
    email_customer VARCHAR(256)
);

CREATE TABLE Pakan_Hewan (
    id_pakan INT(11) PRIMARY KEY,
    tipe_pakan VARCHAR(256),
    stok_pakan INT(11),
    harga_satuan_pakan INT(11),
    detail_pakan TEXT,
    id_kategori_pakan INT(11),
    FOREIGN KEY (id_kategori_pakan) REFERENCES Kategori_Pakan(id_kategori_pakan)
);

CREATE TABLE Pemesanan (
    id_pemesanan INT(11) PRIMARY KEY,
    tanggal_pemesanan DATE,
    id_customer INT(11),
    id_hewan INT(11),
    id_pakan INT(11),
    FOREIGN KEY (id_customer) REFERENCES Customer(id_customer),
    FOREIGN KEY (id_hewan) REFERENCES Hewan(id_hewan),
    FOREIGN KEY (id_pakan) REFERENCES Pakan_Hewan(id_pakan)
);

CREATE TABLE Pembayaran (
    id_pembayaran INT(11) PRIMARY KEY,
    jumlah_pembayaran INT(11),
    detail_pembayaran TEXT,
    id_staff INT(11),
    id_pemesanan INT(11),
    FOREIGN KEY (id_staff) REFERENCES Staff(id_staff),
    FOREIGN KEY (id_pemesanan) REFERENCES Pemesanan(id_pemesanan)
);