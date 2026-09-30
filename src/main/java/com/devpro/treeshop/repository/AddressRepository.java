package com.devpro.treeshop.repository;

import com.devpro.treeshop.model.Address;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AddressRepository extends JpaRepository<Address, Integer> {}

