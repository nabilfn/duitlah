package com.duitlah.api.inventory;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRecipeItemRepository extends JpaRepository<ProductRecipeItem, UUID> {

  List<ProductRecipeItem> findByProductId(UUID productId);

  Optional<ProductRecipeItem> findByIdAndProductId(UUID id, UUID productId);

  boolean existsByProductIdAndIngredientProductId(UUID productId, UUID ingredientProductId);
}
